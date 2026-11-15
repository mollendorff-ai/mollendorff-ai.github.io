# mollendorff-ai.github.io

Home page of Möllendorff AI: open-source tools for finance and AI agents, starting with [Forge](https://github.com/mollendorff-ai/forge). Served at <https://mollendorff.ai/>.

Two static pages, `index.html` in English and `fr/index.html` in Quebec French, each with its styles inline; the top bar links one to the other. Each gives a prompt to paste into an AI, with the one-line install from Forge's README, and `llms.txt` says the same for an agent that reads it. `scripts/check-claims.sh` (run on every push and weekly) checks the case count and that the install line matches Forge's README. It runs no scripts, sets no cookies and loads nothing from other sites. The model shown at the top is a real one: saved as `shop.yaml`, `forge calculate shop.yaml` gives the numbers beside it.

`img/card.png` is the picture shown when the link is shared; `img/studio-phone.jpg` comes from Forge's `docs/images/studio-phone.png`.

The text and images are © Möllendorff AI, all rights reserved. Forge itself is MIT or Apache-2.0, in its own repository.
