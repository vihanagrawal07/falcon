// TEAM FALCON — twin-pusher payload trainer (parametric conceptual airframe)
// Units: mm. Export individual parts with: openscad -o part.stl -D 'part="wing_left"' this_file.scad
// This is a geometry/fit model, not a certified flyable airframe or a manufacturing-ready structural design.

// ---- Principal design parameters (edit these) ----
span = 1160;                 // must remain <= 1200 by event rule
wing_root_chord = 235;
wing_tip_chord = 180;
wing_sweep = 45;
wing_dihedral = 25;
wing_z = 140;
wing_span_half = span/2;
wing_airfoil_t = 0.12;       // NACA 2412 section
htail_span_half = 230;
htail_root_chord = 140;
htail_tip_chord = 100;
aileron_start = 220;
aileron_end = 530;
aileron_chord_fraction = 0.70;
prop_diameter = 203.2;       // 8.0 in; <= 12 in rule, keep disk above belly line
prop_radius = prop_diameter/2;
prop_y = 230;
prop_x = 545;
prop_z = 120;
payload_bay_length = 105;
payload_bay_width = 105;
payload_bay_height = 56;
payload_center_z = 20;
ball_diameter = 42.67;
$fn = 48;
part = "assembly"; // assembly, fuselage, wing_left/right, aileron_left/right, htail_left/right, elevator_left/right, fin, rudder, payload_box, payload_lid, payload_door, motor_pylon_left/right, motor_left/right, propeller_left/right

// ---- Airfoil and loft helpers ----
function mix(a,b,t) = a+(b-a)*t;
function naca_yc(x) = x < 0.4 ? 0.02/0.16*(2*0.4*x-x*x) : 0.02/0.36*((1-2*0.4)+2*0.4*x-x*x);
function naca_dyc(x) = x < 0.4 ? 2*0.02/(0.4*0.4)*(0.4-x) : 2*0.02/(0.6*0.6)*(0.4-x);
function naca_yt(x) = 5*wing_airfoil_t*(0.2969*sqrt(x)-0.1260*x-0.3516*x*x+0.2843*x*x*x-0.1015*x*x*x*x);
function naca_pt(x, upper=true) = let(th=atan(naca_dyc(x)), yt=naca_yt(x), yc=naca_yc(x), s=upper?1:-1) [x-s*yt*sin(th), yc+s*yt*cos(th)];
function airfoil_profile(n=28) = concat(
    [for (i=[0:n]) let(x=(1-cos(180*i/n))/2) naca_pt(x,true)],
    [for (i=[n:-1:0]) let(x=(1-cos(180*i/n))/2) naca_pt(x,false)]
);
function control_profile(x0=0.70,n=14) = concat(
    [for(i=[0:n]) let(x=x0+(1-x0)*i/n) naca_pt(x,true)],
    [for(i=[n:-1:0]) let(x=x0+(1-x0)*i/n) naca_pt(x,false)]
);
function section_at(eta,side,xroot,croot,xtip,ctip,zroot,ztip,profile,halfspan) =
    let(xle=mix(xroot,xtip,eta), c=mix(croot,ctip,eta), z=mix(zroot,ztip,eta),
        pp=profile)
    [for(p=pp) [xle+p[0]*c, side*eta*halfspan, z+p[1]*c]];
function loft_faces(n) = concat(
    [[for(i=[n-1:-1:0]) i], [for(i=[0:n-1]) n+i]],
    [for(i=[0:n-1]) [i,(i+1)%n,n+(i+1)%n,n+i]]
);
module lofted_surface(side, spanfraction0, spanfraction1, xroot, croot, xtip, ctip, zroot, ztip, profile, halfspan=wing_span_half) {
    pp=profile;
    n=len(pp);
    p0=section_at(spanfraction0,side,xroot,croot,xtip,ctip,zroot,ztip,pp,halfspan);
    p1=section_at(spanfraction1,side,xroot,croot,xtip,ctip,zroot,ztip,pp,halfspan);
    polyhedron(points=concat(p0,p1), faces=loft_faces(n), convexity=10);
}
function root_le() = 280;
function tip_le() = root_le()+wing_sweep;
function htail_root_le() = 700;
function htail_tip_le() = 718;

// ---- Main wing / separate ailerons ----
module wing_panel(side=1) {
    difference() {
        lofted_surface(side,0,1,root_le(),wing_root_chord,tip_le(),wing_tip_chord,wing_z,wing_z+wing_dihedral,airfoil_profile());
        // Clearance/notch for independent trailing-edge aileron.
        translate([443,min(side*aileron_start,side*aileron_end),60]) cube([110,aileron_end-aileron_start,180]);
    }
}
module aileron_panel(side=1) {
    lofted_surface(side,aileron_start/wing_span_half,aileron_end/wing_span_half,
        root_le(),wing_root_chord,tip_le(),wing_tip_chord,wing_z,wing_z+wing_dihedral,
        control_profile(aileron_chord_fraction));
}

// ---- Tailplane / elevator ----
module htail_panel(side=1) {
    difference() {
        lofted_surface(side,0,1,htail_root_le(),htail_root_chord,htail_tip_le(),htail_tip_chord,125,132,airfoil_profile(),htail_span_half);
        translate([770,min(side*5,side*220),95]) cube([90,220,90]);
    }
}
module elevator_panel(side=1) {
    lofted_surface(side,5/htail_span_half,220/htail_span_half,htail_root_le(),htail_root_chord,htail_tip_le(),htail_tip_chord,125,132,control_profile(0.70),htail_span_half);
}

// ---- Fuselage (rounded, trainer-style pod; battery/receiver occupy center section) ----
module ellipsoid_at(x,y,z,sx,sy,sz) { translate([x,y,z]) scale([sx,sy,sz]) sphere(r=1); }
module fuselage() {
    hull() {
        ellipsoid_at(25,0,88,25,19,18);
        ellipsoid_at(100,0,89,72,34,32);
        ellipsoid_at(340,0,91,130,43,40);
        ellipsoid_at(570,0,91,115,34,31);
        ellipsoid_at(760,0,100,80,22,20);
        ellipsoid_at(830,0,108,20,12,11);
    }
}

// ---- Vertical tail and rudder ----
module fin() {
    rotate([90,0,0]) linear_extrude(height=12,center=true,convexity=4)
        polygon(points=[[700,120],[815,120],[788,240],[748,255],[755,180]]);
}
module rudder() {
    rotate([90,0,0]) linear_extrude(height=10,center=true,convexity=4)
        polygon(points=[[784,132],[814,132],[788,240],[755,250],[770,188]]);
}

// ---- Four-cell golf-ball bay and common sliding release gate ----
module payload_box() {
    union() {
        difference() {
            // Side-wall shell: open top and bottom; gate closes the bottom.
            translate([0,0,0]) cube([payload_bay_length,payload_bay_width,payload_bay_height],center=true);
            translate([0,0,3]) cube([payload_bay_length-5,payload_bay_width-5,payload_bay_height+4],center=true);
        }
        // Internal cross-divider; each golf ball is independently constrained.
        cube([payload_bay_length-5,2,payload_bay_height-2],center=true);
        cube([2,payload_bay_width-5,payload_bay_height-2],center=true);
        // Locating rails for the one-piece servo-driven sliding door.
        translate([0,-payload_bay_width/2+3,-payload_bay_height/2-2]) cube([payload_bay_length-10,3,4],center=true);
        translate([0,payload_bay_width/2-3,-payload_bay_height/2-2]) cube([payload_bay_length-10,3,4],center=true);
    }
}
module payload_door() {
    translate([0,0,-payload_bay_height/2-5]) cube([payload_bay_length-2,payload_bay_width-2,2],center=true);
}
module payload_lid() {
    translate([0,0,payload_bay_height/2+1]) cube([payload_bay_length-2,payload_bay_width-2,2],center=true);
}

// ---- Twin under-wing rear pusher motor pylons / motor can placeholders ----
module motor_pylon(side=1) {
    // Triangular 5 mm plate braced aft of the wing trailing edge.
    translate([0,side*prop_y,0]) rotate([90,0,0]) linear_extrude(height=5,center=true,convexity=4)
        polygon(points=[[465,wing_z-6],[525,wing_z-6],[prop_x,prop_z+14],[prop_x-18,prop_z-8]]);
}
module motor_can(side=1) {
    translate([prop_x-14,side*prop_y,prop_z]) rotate([0,90,0]) cylinder(h=28,d=28,center=true);
    translate([prop_x+2,side*prop_y,prop_z]) rotate([0,90,0]) cylinder(h=8,d=10,center=true);
}
module prop_blade(angle=0) {
    rotate([angle,0,0]) hull() {
        translate([0,0,24]) scale([2.4,8,18]) sphere(r=1,$fn=20);
        translate([0,0,62]) scale([2.1,13,17]) sphere(r=1,$fn=20);
        translate([0,0,89]) scale([1.4,8,11]) sphere(r=1,$fn=20);
    }
}
module propeller(side=1) {
    translate([prop_x+20,side*prop_y,prop_z]) {
        rotate([0,90,0]) cylinder(h=16,d=13,center=true);
        prop_blade(0);
        prop_blade(180);
    }
}

// Small simplified servo blocks are provided as installation references, not functional mechanisms.
module servo_block(x,y,z) { translate([x,y,z]) cube([23,12,24],center=true); }

module assembly() {
    color("#d8d4c9") fuselage();
    color("#c9d7b8") wing_panel(-1); color("#c9d7b8") wing_panel(1);
    color("#d9caa8") aileron_panel(-1); color("#d9caa8") aileron_panel(1);
    color("#c9d7b8") htail_panel(-1); color("#c9d7b8") htail_panel(1);
    color("#d9caa8") elevator_panel(-1); color("#d9caa8") elevator_panel(1);
    color("#c9d7b8") fin(); color("#d9caa8") rudder();
    translate([350,0,payload_center_z]) color("#c9c9c9") payload_box();
    translate([350,0,payload_center_z]) color("#999999") payload_lid();
    translate([350,0,payload_center_z]) color("#777777") payload_door();
    color("#aaaaaa") motor_pylon(-1); color("#aaaaaa") motor_pylon(1);
    color("#777777") motor_can(-1); color("#777777") motor_can(1);
    color("#333333") propeller(-1); color("#333333") propeller(1);
    color("#5f6c76") servo_block(430,-260,145); color("#5f6c76") servo_block(430,260,145);
    color("#5f6c76") servo_block(390,0,98); color("#5f6c76") servo_block(730,0,130);
    color("#5f6c76") servo_block(350,58,payload_center_z);
}

if (part=="assembly") assembly();
else if (part=="fuselage") fuselage();
else if (part=="wing_left") wing_panel(-1);
else if (part=="wing_right") wing_panel(1);
else if (part=="aileron_left") aileron_panel(-1);
else if (part=="aileron_right") aileron_panel(1);
else if (part=="htail_left") htail_panel(-1);
else if (part=="htail_right") htail_panel(1);
else if (part=="elevator_left") elevator_panel(-1);
else if (part=="elevator_right") elevator_panel(1);
else if (part=="fin") fin();
else if (part=="rudder") rudder();
else if (part=="payload_box") payload_box();
else if (part=="payload_lid") payload_lid();
else if (part=="payload_door") payload_door();
else if (part=="motor_pylon_left") motor_pylon(-1);
else if (part=="motor_pylon_right") motor_pylon(1);
else if (part=="motor_left") motor_can(-1);
else if (part=="motor_right") motor_can(1);
else if (part=="propeller_left") propeller(-1);
else if (part=="propeller_right") propeller(1);
