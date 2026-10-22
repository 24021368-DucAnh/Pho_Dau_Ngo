# Phở workflow domain model — decision record

Status: Proposed implementation baseline for M2 vertical slice
Date: 2026-10-22

## Decision

Do not model phở bò tái and phở bò chín as the same `add_beef` action with different blanch durations. The two dishes use different preparation histories and ingredient states.

## Culinary domain terms

- **Tái** describes the serving/preparation style for beef: suitable raw beef is sliced thinly and placed on noodles; hot broth is poured over it in the bowl to cook it rare/medium-rare depending on slice thickness, broth temperature and service practice.
- **Chín** describes beef cooked before bowl assembly. Depending on the shop and recipe, suitable cuts such as brisket (nạm), flank/brisket-like cuts, or shank can be simmered until cooked/tender, then cooled/handled safely and sliced for service.
- **Nạm, gầu, bắp, gân, sách and bò viên** are not synonyms for tai/chin. They refer to distinct cuts, tissues or toppings and must eventually be represented as separate ingredient/product identities with their own preparation rules.
- Rice noodles are blanched separately from beef. Broth is a soup component and finishing liquid, not a substitute for the separate pre-cooking process used for phở chín.

## Vertical-slice workflow

### Shared
1. Maintain hot broth as a prepared/held component (full stock-making is abstracted in this slice).
2. Blanch rice noodles separately and drain.
3. Assemble the selected recipe in a bowl.
4. Add hot broth as the finishing action and mark the bowl ready only when required components and states are valid.

### Phở bò tái
1. Select suitable beef and prepare/slice thinly.
2. Blanch noodles separately and place in bowl.
3. Add raw thin-sliced beef to the bowl.
4. Pour hot broth directly over beef as the final cooking step.
5. Mark complete only after all steps succeed.

### Phở bò chín
1. Select a suitable cut for simmering.
2. Simmer/pre-cook it to cooked/tender state. Game time may be compressed but the action and state must remain explicit.
3. Hold/cool with safe handling abstraction, then slice for service.
4. Blanch noodles separately and place in bowl.
5. Add cooked, sliced beef.
6. Pour hot broth and mark complete.

## Data and state invariants

- Recipe data declares method, required ingredient state and ordered steps; variant labels alone are insufficient.
- Ingredient identity, preparation state and bowl assembly state are separate concepts.
- A failed step does not consume stock or advance bowl state.
- A successful step consumes stock exactly once.
- A completed bowl cannot be served if its recipe is incomplete or not associated with an order.
- Cancellation clears active station timers and records waste exactly once.
- A single bowl has one owner at a time; reject pickup of another bowl while one is held.

## Gameplay abstractions and limits

- Long simmering can be represented by short configurable gameplay time; do not imply that seconds in game equal culinary time.
- The model is a coherent reference workflow, not a claim that every phở shop or region uses one identical recipe.
- Do not claim safe food handling from a state flag alone. Real food safety depends on temperature, time, hygiene and local guidance.
- CI verifies parsing, automated contracts and exports; direct in-game handling/feel still needs a manual playtest.

## Evidence consulted

- Michelin Guide, “How to Make Pho Like a MICHELIN Restaurant in Hanoi”: https://guide.michelin.com/th/en/article/dining-in/how-to-make-pho-like-michelin-restaurant-in-hanoi
- Whats4Eats, “Pho Bo recipe”: https://www.whats4eats.com/soups/pho-bo-recipe
- Gulf News, “Step-by-step guide to making authentic Vietnamese pho bo chin”: https://gulfnews.com/food/guide-cooking/watch-step-by-step-guide-to-making-authentic-vietnamese-pho-bo-chin-or-beef-brisket-pho-1.1612096473044
- The Seasoned Wok, “Pho Tai”: https://www.theseasonedwok.com/pho-tai-vietnamese-pho-recipe-with-rare-steak/
- Local Vietnam, “Pho”: https://localvietnam.com/culture/cuisine/pho/

Sources describe common approaches; recipes vary by shop and region.
