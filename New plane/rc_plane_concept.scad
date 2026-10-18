// Team Falcon RC plane — revised full-scale conceptual model, units in millimetres.
// The 2-inch fuselage thickness is implemented as a 50.8 mm maximum vertical height.
// Control surfaces are separate hinge-pin parts; this is still a concept, not an airworthy design.

$fn = 32;
part = "aircraft"; // aircraft | fixed_airframe | aileron_left | aileron_right | elevator | rudder | controls | wing_fixed | payload_bay

// PDF design dimensions / targets
wing_span = 1150;
wing_chord = 180;
half_span = wing_span/2;
wing_le_x = 300;
wing_root_z = 25.4;
wing_dihedral_deg = 3;
wing_incidence_root_deg = 2;
wing_washout_deg = 1;
fuselage_length = 800;
fuselage_max_height = 2*25.4; // 2 inches = 50.8 mm
fuselage_scale = fuselage_max_height/70; // preserve cross-section proportions from the prior concept

tail_span = 380;
tail_chord = 130;
tail_le_x = 650;
tail_z = 10;

// Approximate flat-bottom/gently-cambered airfoil, max thickness about 11.7% chord.
foil = [
    [0.00, 0.000], [0.035, 0.030], [0.12, 0.075], [0.30, 0.110],
    [0.50, 0.095], [0.75, 0.060], [0.92, 0.025], [1.00, 0.000],
    [0.92,-0.008], [0.75,-0.012], [0.50,-0.012], [0.30,-0.007],
    [0.12,-0.003], [0.035,-0.002]
];
NFOIL = len(foil);

function chord_at(s) = s <= 565.5 ? wing_chord : wing_chord - 30*(s-565.5)/10;
function alpha_at(s) = wing_incidence_root_deg - wing_washout_deg*(s/575.5);
function wing_point(s, side, i) =
    let(c = chord_at(s), a = alpha_at(s),
        xp = foil[i][0]*c - 0.25*c,
        zp = foil[i][1]*c,
        xr = 0.25*c + xp*cos(a) + zp*sin(a),
        zr = -xp*sin(a) + zp*cos(a))
    [wing_le_x + xr, side*(s - 0.5), wing_root_z + s*tan(wing_dihedral_deg) + zr];
function wing_points(side) = [for (s=[0,565.5,575.5]) for (i=[0:NFOIL-1]) wing_point(s,side,i)];
function wing_side_faces(side) = concat(
    [for (j=[0:1]) for (i=[0:NFOIL-1])
        side > 0
          ? [j*NFOIL+i, j*NFOIL+(i+1)%NFOIL, (j+1)*NFOIL+(i+1)%NFOIL]
          : [j*NFOIL+i, (j+1)*NFOIL+i, (j+1)*NFOIL+(i+1)%NFOIL]
    ],
    [for (j=[0:1]) for (i=[0:NFOIL-1])
        side > 0
          ? [j*NFOIL+i, (j+1)*NFOIL+(i+1)%NFOIL, (j+1)*NFOIL+i]
          : [j*NFOIL+i, (j+1)*NFOIL+(i+1)%NFOIL, j*NFOIL+(i+1)%NFOIL]
    ]
);
function wing_faces(side) = concat(
    wing_side_faces(side),
    side > 0
      ? [[for(i=[NFOIL-1:-1:0]) i], [for(i=[2*NFOIL:3*NFOIL-1]) i]]
      : [[for(i=[0:NFOIL-1]) i], [for(i=[3*NFOIL-1:-1:2*NFOIL]) i]]
);

module wing_half(side) {
    polyhedron(points=wing_points(side), faces=wing_faces(side), convexity=10);
}

module wing_root_transform(side, twist=1.2) {
    translate([wing_le_x+45,0,wing_root_z])
        rotate([side*wing_dihedral_deg,twist,0]) children();
}

module tube_y(x,y,z,len,od=5.0,id=2.2) {
    difference() {
        translate([x,y,z]) rotate([90,0,0]) cylinder(h=len,d=od,center=true);
        translate([x,y,z]) rotate([90,0,0]) cylinder(h=len+0.6,d=id,center=true);
    }
}

module tube_z(x,y,z,len,od=5.0,id=2.2) {
    difference() {
        translate([x,y,z]) cylinder(h=len,d=od,center=true);
        translate([x,y,z]) cylinder(h=len+0.6,d=id,center=true);
    }
}

module wing_fixed() {
    union() {
        difference() {
            union() { wing_half(1); wing_half(-1); }
            // Aileron cutouts: 220 x 35 mm each, with nominal 0.5 mm perimeter clearance.
            for (side=[-1,1]) {
                y0 = side > 0 ? 329.5 : -550.5;
                wing_root_transform(side)
                    translate([99.5,y0,-25]) cube([36.0,221.0,65]);
            }
            // Relief pockets for the alternating moving hinge barrels.
            for (side=[-1,1], cy=[380,455,520]) {
                wing_root_transform(side)
                    translate([97,side*cy,3.5]) rotate([90,0,0])
                        cylinder(h=20.6,d=5.4,center=true);
            }
        }
        // Fixed wing hinge knuckles and attachment webs.
        for (side=[-1,1], cy=[345,420,495]) {
            wing_root_transform(side) {
                tube_y(97,side*cy,3.5,12);
                translate([94,side*cy-6,1.5]) cube([3.5,12,4]);
            }
        }
    }
}

// 35 mm trailing-edge aileron profile in wing-root local coordinates.
aileron_profile = [
    [100,9.6], [108,7.3], [118,4.6], [128,1.7], [135,0.0],
    [135,-0.5], [128,-1.7], [118,-1.9], [108,-1.8], [100,-1.6]
];
module span_profile(profile,y0,length) {
    translate([0,y0,0]) rotate([-90,0,0]) linear_extrude(height=length,convexity=5)
        polygon(points=[for(p=profile) [p[0],-p[1]]]);
}

module aileron_part(side) {
    y0 = side > 0 ? 330 : -550;
    union() {
        wing_root_transform(side)
            span_profile(aileron_profile,y0,220);
        // Moving hinge knuckles and narrow webs, alternating with the fixed wing knuckles.
        for (cy=[380,455,520]) {
            wing_root_transform(side) {
                tube_y(97,side*cy,3.5,20);
                translate([97,side*cy-10,3.0]) cube([3.2,20,1.0]);
            }
        }
        // Simple under-surface servo horn with a 2.6 mm linkage hole.
        wing_root_transform(side) difference() {
            translate([111,side*500-2,-14]) cube([4,4,14]);
            translate([113,side*500,-8]) rotate([90,0,0]) cylinder(h=4.6,d=2.6,center=true);
        }
    }
}

module ellipsoid(x,ry,rz,rx=12,z=0) {
    translate([x,0,z]) scale([rx,ry*fuselage_scale,rz*fuselage_scale]) sphere(r=1);
}
module fuselage() {
    hull() {
        ellipsoid(10,14,18,10,0);
        ellipsoid(55,22,27,28,0);
        ellipsoid(200,27,35,90,0);
        ellipsoid(345,24,31,95,0);
        ellipsoid(500,20,27,90,0);
        ellipsoid(650,15,20,80,0);
        ellipsoid(770,9,14,30,0);
        ellipsoid(795,5,8,5,0);
    }
}

module wing_saddle() {
    hull() {
        translate([330,0,17.4]) scale([65,26,8]) sphere(r=1);
        translate([445,0,17.4]) scale([45,22,8]) sphere(r=1);
    }
}

module payload_bay() {
    // PDF payload envelope 130 x 130 x 55 mm, centred near x=345 (25% chord station).
    x0=280; y0=-65; z0=-38;
    union() {
        difference() {
            translate([x0,y0,z0]) cube([130,130,55]);
            translate([x0+2.4,y0+2.4,z0+2.4]) cube([125.2,125.2,55]);
        }
        translate([x0+2.4,y0+2.4,z0]) cube([125.2,125.2,2.4]);
        translate([x0+63.8,y0+2.4,z0+2.4]) cube([2.4,122.0,52.6]);
        translate([x0+2.4,y0+63.8,z0+2.4]) cube([125.2,2.4,52.6]);
    }
}

module tailplane_fixed() {
    union() {
        difference() {
            translate([650,-190,10]) cube([97.4,380,4]);
            // Pockets for moving elevator knuckles; prevent fusion/binding at the hinge.
            for (cy=[-122.5,-40,40,122.5])
                translate([745.2,cy,12]) rotate([90,0,0])
                    cylinder(h=20.6,d=5.4,center=true);
        }
        // Fixed elevator hinge knuckles.
        for (cy=[-165,-80,0,80,165]) {
            tube_y(745.2,cy,12,12);
            translate([742.0,cy-6,10.5]) cube([3.2,12,3]);
        }
    }
}

module elevator_part() {
    union() {
        // Split left/right elevator halves leave clearance around the central rudder.
        translate([748.0,-190,10]) cube([32,186.5,4]);
        translate([748.0,3.5,10]) cube([32,186.5,4]);
        for (cy=[-122.5,-40,40,122.5]) {
            tube_y(745.2,cy,12,20);
            // Narrow web lies in the hinge relief and joins the elevator leading edge.
            translate([747.0,cy-10,11.5]) cube([1.3,20,1.0]);
        }
        // Simple pushrod horn, shown as an attachment tab below the elevator.
        difference() {
            translate([760,12,0]) cube([4,6,11]);
            translate([762,15,5]) rotate([90,0,0]) cylinder(h=6.6,d=2.6,center=true);
        }
    }
}

module extruded_xz(outline,y0,thickness) {
    translate([0,y0+thickness,0]) rotate([90,0,0]) linear_extrude(height=thickness,convexity=5)
        polygon(points=outline);
}

module fin_fixed() {
    fin_outline = [[630,12],[760,12],[760,150],[745,162],[710,150],[680,112],[650,58]];
    union() {
        difference() {
            extruded_xz(fin_outline,-3,6);
            // Reliefs for alternating moving rudder hinge knuckles.
            for (cz=[40,78,116])
                translate([758,0,cz]) cylinder(h=18.6,d=5.4,center=true);
        }
        // Fixed vertical hinge knuckles and small webs.
        for (cz=[22,58,96,134,150]) {
            tube_z(758,0,cz,10);
            translate([755,-2.5,cz-5]) cube([3.2,5,10]);
        }
    }
}

module rudder_part() {
    rudder_outline = [[760.6,12],[800,12],[794,50],[782,100],[768,140],[760.6,150]];
    union() {
        extruded_xz(rudder_outline,-3,6);
        for (cz=[40,78,116]) {
            tube_z(758,0,cz,18);
            // Narrow web connects the moving barrel to the rudder leading edge.
            translate([757.8,-0.5,cz-9]) cube([3.0,1.0,18]);
        }
        // Rudder control horn, simple 2.6 mm pushrod hole.
        difference() {
            translate([775,1.5,58]) cube([5,9,4]);
            translate([777.5,6,60]) rotate([0,90,0]) cylinder(h=5.6,d=2.6,center=true);
        }
    }
}

module strut(p1,p2,r=3) {
    hull() { translate(p1) sphere(r=r); translate(p2) sphere(r=r); }
}
module wheel_y(x,y,z,diameter,width) {
    translate([x,y,z]) rotate([90,0,0]) cylinder(h=width,d=diameter,center=true);
}
module landing_gear() {
    // Main wheels moved aft of the payload box and supported from the fuselage.
    for (side=[-1,1]) {
        strut([440,0,-17],[455,side*84,-46],3.0);
        strut([465,0,-17],[455,side*84,-46],2.2);
        wheel_y(455,side*90,-48,50,12);
        wheel_y(455,side*96.4,-48,24,1.2);
    }
    // Single smaller nose wheel and fork, for a tricycle arrangement.
    strut([132,-4,-17],[135,-4,-34],2.4);
    strut([132,4,-17],[135,4,-34],2.4);
    wheel_y(135,0,-36,38,10);
    wheel_y(135,5.6,-36,18,1.2);
}

module motor_and_prop() {
    // Visual candidate: 2212 motor / 10 x 4.5 in (254 mm) prop, down/right shim angles.
    rotate([0,1.5,1.0]) {
        translate([10,0,0]) rotate([0,90,0]) cylinder(h=12,d=22,center=true);
        translate([0,0,0]) rotate([0,90,0]) cylinder(h=5,d=18,center=true);
        for (side=[-1,1]) hull() {
            translate([0,0,side*20]) scale([1.7,12,14]) sphere(r=1);
            translate([0,0,side*105]) scale([1.2,5.5,22]) sphere(r=1);
        }
    }
}

module fixed_airframe() {
    union() {
        fuselage();
        wing_saddle();
        wing_fixed();
        payload_bay();
        tailplane_fixed();
        fin_fixed();
        landing_gear();
        motor_and_prop();
    }
}

module controls() {
    aileron_part(-1);
    aileron_part(1);
    elevator_part();
    rudder_part();
}

module aircraft() {
    union() {
        fixed_airframe();
        controls();
    }
}

if (part == "fixed_airframe") {
    fixed_airframe();
} else if (part == "aileron_left") {
    aileron_part(-1);
} else if (part == "aileron_right") {
    aileron_part(1);
} else if (part == "elevator") {
    elevator_part();
} else if (part == "rudder") {
    rudder_part();
} else if (part == "controls") {
    controls();
} else if (part == "wing_fixed") {
    wing_fixed();
} else if (part == "payload_bay") {
    payload_bay();
} else {
    aircraft();
}
