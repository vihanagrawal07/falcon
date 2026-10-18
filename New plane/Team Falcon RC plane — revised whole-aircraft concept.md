# Team Falcon RC plane — revised whole-aircraft concept

This is an updated **1:1 visualization/layout model** based on the supplied Team Falcon proposal and your requested revisions. The fuselage hull is reduced to a maximum vertical thickness of **2 inches (50.8 mm)**, with its cross-section width reduced proportionally. The paired main wheels are now aft of the payload bay and supported from the fuselage, and a smaller nose wheel completes a tricycle arrangement. Ailerons, elevator halves, and rudder are separate hinge-pin parts in the neutral assembly.

## Files

- [`rc_plane_concept.stl`](rc_plane_concept.stl) — full neutral-position aircraft assembly. It contains six separate watertight shells: fixed airframe, two ailerons, two elevator halves, and rudder.
- [`rc_plane_fixed_airframe.stl`](rc_plane_fixed_airframe.stl) — fuselage, wing and tail fixed surfaces, payload bay, motor/prop visual, and landing gear with hinge knuckles.
- [`control_aileron_left.stl`](control_aileron_left.stl) and [`control_aileron_right.stl`](control_aileron_right.stl) — independent outer ailerons with hinge knuckles and linkage tabs.
- [`control_elevator.stl`](control_elevator.stl) — left and right elevator halves, split to clear the central rudder.
- [`control_rudder.stl`](control_rudder.stl) — rudder with vertical hinge knuckles and a linkage tab.
- [`control_surfaces_neutral.stl`](control_surfaces_neutral.stl) — the five movable surface shells in their neutral positions.
- [`rc_plane_concept.scad`](rc_plane_concept.scad) — editable OpenSCAD source for all parts and the assembly.
- [`rc_plane_concept_preview.png`](rc_plane_concept_preview.png) and [`rc_plane_concept_side.png`](rc_plane_concept_side.png) — updated views.

STL has no unit metadata; import at **100% scale in millimetres**. The full aircraft bounding box is approximately **804.1 × 1,150 × 288.9 mm** (longitudinal × spanwise × vertical). The fixed airframe and the individual controls are watertight; controls remain deliberately separate from the fixed airframe so they can be assembled as moving parts.

## Revised and PDF-derived dimensions

| Feature | Modelled value |
|---|---:|
| Fuselage hull maximum vertical thickness | **50.8 mm (2.00 in)** |
| Fuselage length | **800 mm** |
| Proportional fuselage cross-section scale | **0.7257×** prior hull width and height profiles; longitudinal length unchanged |
| Wing span | **1,150 mm** |
| Wing root chord | **180 mm** |
| Leading-edge sweep | **0°** |
| Dihedral | **3° per side** |
| Incidence / washout | **+2° at root to about +1° at tip** |
| Horizontal tailplane | **380 × 130 mm** overall |
| Elevator | **32 mm chord**, split left/right around rudder |
| Vertical fin | about **150 mm high**, **170 mm total root chord** including rudder |
| Four-cell payload bay | **130 × 130 × 55 mm** outer envelope; positioned beneath wing near the proposal’s nominal CG station |
| Ailerons | **220 × 35 mm each** nominal control-surface body |
| Main wheels | **50 mm diameter**, at about x=455 mm, aft of payload bay |
| Nose wheel | **38 mm diameter**, at about x=135 mm |
| Candidate propeller diameter | **254 mm (10 in)** |

The 2-inch thickness applies to the fuselage hull’s maximum vertical cross-section; the fuselage width is reduced by the same factor to preserve the prior cross-section proportions. Wheel diameters, track, struts, and nose-gear dimensions were not provided by the PDF, so they are model assumptions. The bay occupies approximately x=280–410 mm; main-wheel centres are at x=455 mm. Gear struts attach to the fuselage, not the payload box.

The wing uses a simplified flat-bottom/gently cambered section with about 11.7% maximum thickness. The last 10 mm at each tip tapers slightly as a rounded-tip approximation. The fuselage, tail sections, gear, control-surface profiles, and all hinge details are conceptual where the PDF did not provide manufacturing geometry. The motor/prop assembly is a visual representation of the PDF’s candidate 2212/1000 KV motor and 10 × 4.5-inch prop; prop pitch and performance are not simulated.

## Moving controls and assembly

The full assembly STL places all surfaces in neutral position. **STL cannot store animation or articulated joints.** The fixed airframe and control surfaces are separate solids; the individual surface STLs preserve their matching hinge features and coordinates. Insert nominal **2.0 mm pins/rods** through the **2.2 mm hinge bores** after aligning the fixed and moving knuckles. Pin hardware is not included. The elevator file contains two independent halves; both are arranged to sit either side of the rudder.

The hinge axes are spanwise through the ailerons and elevator, and vertical through the rudder. The control-linkage tabs have nominal 2.6 mm holes. Depending on printer/material tolerances, the pin bores and linkage holes may need drilling or reaming. Move the surfaces by rotating them about their pin axes in CAD, or assemble with suitable pins/hinges. The model does not include servos, pushrods, or electrical actuation.

The PDF’s initial throw targets—aileron about **+12° up / −10° down**, elevator **±12°**, rudder **±20°**—are references only. Clearances and hinge geometry are conceptual; no full-range interference, loads, fatigue, or flight testing have been validated.

## Limitations

The PDF treats dimensions and angles as proposed targets requiring validation. It also gives an empty-mass target of about **750 g**, a **1,000 g** empty-aircraft limit, and an empty thrust-to-weight cap of **1.0**. This model does not verify mass, rule compliance, strength, aerodynamics, CG, payload balance, thrust, stability, stall speed, or flight performance.

The 1.15 m span is not a single-piece desktop print. This is not a build-ready or flight-certified design: there are no print splits, validated structural joiners, material/reinforcement schedule, servo sizing, battery restraint, motor mount design, linkage setup, or verified load paths. Use the files for visualization and layout only. Create and test a separate engineering design, measure the completed aircraft, and complete appropriate supervised structural and flight tests before flying.
