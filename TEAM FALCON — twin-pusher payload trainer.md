# TEAM FALCON — twin-pusher payload trainer

## Deliverables

- `assembly.stl` — complete, multi-body reference assembly in millimetres.
- `rc_trainer_parametric.scad` — editable OpenSCAD source; change the top-level parameters and select a `part` value to regenerate each STL.
- Individual component STLs — fuselage, left/right wing panels, ailerons, tailplane halves, elevators, fin, rudder, payload cassette/lid/release gate, motor pylons, motor cans and propellers.
- `preview.png` and `preview_underside.png` — shaded views of the assembled concept.
- `engineering_check.md` — dimensions, aerodynamic estimates and build cautions.

STL files contain mesh geometry, not editable CAD parameters. Use the SCAD source for parametric changes. The assembly STL intentionally contains multiple separate/intersecting component meshes, so it is not a single watertight solid. Every individually exported part was checked as a watertight mesh. STL has no unit metadata; import at 100% and interpret dimensions as millimetres.

## Design intent

This is a high-wing, hand-launched trainer with a cambered NACA 2412 wing; two rear-facing pusher propellers mounted below the wing; separate ailerons, elevator and rudder; a conventional tail; no landing gear; and a detachable four-cell golf-ball cassette centered close to the estimated loaded CG. The bay is approximately 105 × 105 × 56 mm, with four individually partitioned cells, a removable loading lid and one common sliding release gate.

The 1,160 mm span stays below the rulebook's 1,200 mm maximum. The horizontal tail spans 460 mm, sized for a first-pass horizontal-tail volume coefficient of about 0.42. The modeled propeller blade diameter is approximately 200 mm (about 7.9 in), under the 12 in maximum. The fuselage is about 850 mm long. The geometry is a fit/layout model for a foam-board/balsa/bamboo build, not a recommendation to 3D-print a solid 1.16 m wing. Use foam-board/Depron skins, a spar sized and tested for the loads, and plywood/balsa reinforcement at motor and servo attachments.

Example export from OpenSCAD: `openscad -o assembly.stl -D 'part="assembly"' rc_trainer_parametric.scad`. Replace `assembly` with a component name such as `wing_left`, `aileron_right` or `payload_box` for a single-body STL.

## Build/electronics changes from the reference list

The uploaded materials list shows one 2212/1000 KV motor, one ESC and 10 × 4.5 in propellers. A twin-propeller layout cannot use that single-motor power train: it needs two matched motors and two separate ESCs. The model uses the 2212/1000 KV class, two 30 A ESCs, 3S 2200 mAh LiPo and two non-metallic 8 × 4.5 in pusher propellers as starting selections. Confirm each motor manufacturer's current/thrust data with the exact propeller and battery before flight; do not assume these combinations are compatible just from the nominal ratings. Use a suitably rated battery (30C is a sensible minimum starting point), wattmeter, and temperature checks. Isolate the positive/BEC lead from one ESC when paralleling the throttle signal unless the ESC manufacturer explicitly permits both BECs in parallel.

Five servos are planned: two ailerons, elevator, rudder and the release gate. Ailerons can share a channel with a Y lead; the twin ESCs share throttle; this fits a 6-channel transmitter. The source shows servo blocks only as location references. Actual hinges, horns, pushrods, servo mounts, hatch latch, motor mounts, wiring and structural spars must be designed and installed by the builder.

## First-pass setup targets

- Estimated 25%-MAC CG: about 354 mm aft of the nose datum; the payload center is at x = 350 mm. Place the battery so the *measured* aircraft CG meets the target with and without the balls.
- Suggested starting control throws: ailerons ±12°, elevator ±10°, rudder ±20°, with conservative expo if the radio supports it. Start with reduced rates and adjust after glide tests.
- A +2° wing incidence relative to the fuselage datum is a reasonable construction starting point; the exported geometry itself is neutral. Set the tailplane close to 0° incidence and re-trim from glide tests.
- Hand-launch only after the full-payload CG, prop rotation, control direction, failsafe and motor synchronization have been checked.

## Critical limits and cautions

The event requires empty-aircraft thrust-to-weight ratio (T/W) no greater than 1.0 and empty weight no greater than 1 kg. The nominal 0.90 kg empty mass in the calculations is a *target estimate*, not a measured property of these STL meshes. Weigh the completed aircraft and use a thrust stand to measure combined static thrust; select/limit the exact propeller and power setting so the event's T/W rule is satisfied. Do not fly if the loaded aircraft cannot be safely hand-launched and climb with margin.

There is no landing gear by request. A fixed under-wing pusher propeller disk is lower than the fuselage belly in the current layout; on a belly landing the props may touch first. Use folding/impact-tolerant pusher propellers or a tested sacrificial prop-saver arrangement, and verify ground clearance on the actual airframe. This is especially important because the event only explicitly tolerates propeller breakage in the obstacle-round landing rule; it does not make a prop strike safe for people or the battery. The payload cassette also projects below the fuselage and needs a securely attached, crush-tolerant mount.

This is a preliminary design model, not a flight-certified aircraft, structural analysis, CFD result or guarantee of flight performance. Build and inspect a prototype, balance it, bench-test the power system and obtain experienced RC-aircraft supervision before flight.
