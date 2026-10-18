# Engineering screening — preliminary, not certification

## Rulebook constraints matched in the model

| Requirement | Rule | Model |
|---|---:|---:|
| Wingspan | ≤ 1,200 mm | 1,160 mm |
| Empty-aircraft mass | ≤ 1.0 kg | 0.90 kg is a build target only; must be measured |
| Empty static T/W | ≤ 1.0 | Select/limit the actual motor/prop combination after a thrust-stand test |
| Prop diameter | ≤ 12 in | about 200 mm / 7.9 in in the STL |
| No landing gear | User request | Hand launch; belly landing, with the prop/cassette ground-clearance warning below |

## Geometry and stability screening

The trapezoidal wing uses a NACA 2412 section, 235 mm root chord and 180 mm tip chord. Planform area is approximately 0.2407 m² and aspect ratio is 5.59. The calculated mean aerodynamic chord is about 208.7 mm, with its leading edge about 301.5 mm aft of the nose datum. The 25%-MAC starting CG is therefore about 353.7 mm aft of the nose. The payload cassette center is x = 350 mm; four standard-size golf balls at that station add little longitudinal CG shift. The final battery position must be set by balancing the actual aircraft, first empty and then loaded.

The horizontal tail has a 460 mm span and trapezoidal 140/100 mm chords, giving about 0.0552 m² area. Its approximate horizontal-tail volume coefficient is 0.42 using the 25%-MAC CG and tail quarter-chord moment arm. This is a reasonable first-pass trainer-scale value, not a substitute for stability analysis or trim testing. The exported wing/tail incidence is neutral; the README gives a suggested +2° wing build shim as a starting point.

## Payload and mass

The cassette external envelope is approximately 105 × 105 × 56 mm. Four separated cells are sized around 42.67 mm golf balls; the 2 × 2 arrangement is symmetric about the aircraft centerline. Assuming 45.93 g per ball, the full payload is about 183.7 g. A nominal 0.90 kg empty aircraft becomes about 1.084 kg loaded. The competition document has no loaded-mass ceiling, but the loaded mass still determines launch and climb performance.

The 0.90 kg empty mass is an estimate for a carefully built foam-board airframe with spars, two motors, two ESCs, 3S 2200 mAh battery, five servos, receiver, wiring and hardware. No mass is encoded in STL geometry. Weigh the finished airframe and keep it below the event's 1 kg empty limit.

## Aerodynamic first-order estimates

Using sea-level density 1.225 kg/m³ and an assumed CLmax of 1.2, stall speed from `Vs = sqrt(2 W / (rho S CLmax))` is approximately:

- Empty at 0.90 kg: 7.06 m/s (25.4 km/h); wing loading 37.4 g/dm².
- Loaded at 1.084 kg: 7.75 m/s (27.9 km/h); wing loading 45.0 g/dm².

An initial approach/launch margin of roughly 1.3 × Vs corresponds to about 33 km/h empty and 36 km/h loaded. These are analytical estimates; actual stall speed depends on build quality, airfoil finish, Reynolds number, propwash, CG, trim and control deflection. Do not use calculated stall speed as a hand-launch target without experienced pilot testing.

## Power-system constraint requiring measurement

Two 2212/1000 KV-class motors with 8 × 4.5 in props are a plausible starting point for the requested twin-pusher layout, but actual thrust, current and temperature depend on the exact motor, propeller and battery. The rule caps empty static T/W at 1.0. At the nominal 0.90 kg empty mass, combined static thrust must not exceed about 0.90 kgf (8.83 N). A combined 0.80–0.90 kgf would give a loaded static T/W around 0.74–0.83. No thrust value is claimed as measured. Check both motors together on a thrust stand and wattmeter; use the exact propeller, battery and ESCs intended for flight. If thrust/current is unsuitable, change the propeller or power setting and re-check both performance and event compliance.

## Gearless belly-landing risk

In the exported coordinates, the propeller tips reach z ≈ 20 mm while the fuselage belly is at z ≈ 51 mm; the payload release gate reaches still lower. Thus the props and bay are the likely first ground contacts in a level belly landing. Since the aircraft has no landing gear by request, the physical build needs folding/impact-tolerant pusher propellers or a tested sacrificial prop-saver arrangement, plus a crush-tolerant, positively retained payload cassette and safe ground-clearance checks. The current STL propellers show the deployed geometry and do not model folding hinges. A prop strike can injure people or damage the LiPo; conduct first tests only in a controlled clear area.

## Mesh checks

OpenSCAD exported the complete reference assembly and 20 individual part STLs. All individual component meshes passed a watertight-mesh check. `assembly.stl` intentionally preserves multiple separate bodies and overlaps at assembly interfaces; it is not expected to be one watertight printable solid. The STL files do not include hinges, pushrods, horns, actual motor mounts, structural spars, adhesives, electrical parts, or foldable prop mechanisms.