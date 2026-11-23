#!mainFile "../../main.opy"

# Shared immutable colors and positions.
# Use Vector directions directly for unit offsets; scaling adds a multiplication and scalar.
# Shared offsets below cache that expression once, saving elements across repeated uses.
globalvar offsetUpThreeQuartersConst = 0.75 * Vector.UP    # Vertical offset of 0.75 m for labels, icons and visibility checks. Source uses: 7 (excluding declaration).
globalvar offsetUpHalfConst = 0.5 * Vector.UP              # Vertical offset of 0.5 m for labels and effects. Source uses: 7 (excluding declaration).
globalvar losOffsetConst = 1.2 * Vector.UP                 # Vertical offset of 1.2 m used by line-of-sight checks. Source uses: 16 (excluding declaration).
globalvar dummyHoldingPositionConst = vect(500, 500, 500)  # Off-map holding position for newly created or reconfigured dummy bots. Source uses: 6 (excluding declaration).
globalvar offsetDownHundredConst = -100 * Vector.UP       # Downward offset of 100 m for raycasts, hidden effects and dead-player storage. Source uses: 7 (excluding declaration).
globalvar offsetUpOneAndHalfConst = 1.5 * Vector.UP       # Vertical offset of 1.5 m for the pregame camera and player labels. Source uses: 6 (excluding declaration).
globalvar offsetUpQuarterConst = 0.25 * Vector.UP         # Vertical offset of 0.25 m for impulses, power-up drops and effects. Source uses: 5 (excluding declaration).
# Match state and configuration.
