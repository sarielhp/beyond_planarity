# Beyond Planarity: On Geometric Intersection Graphs

This directory contains the source code for the presentation "Beyond planarity: On geometric intersection graphs" by Sariel Har-Peled. The slide deck is built using [Quarto](https://quarto.org/) with the `revealjs` format.

## Generating the Presentation

To generate the presentation, you will need to have [Quarto installed](https://quarto.org/docs/get-started/).

Once installed, you can render the `.qmd` file to an HTML presentation by running the following command in this directory:

```bash
quarto render presentation.qmd
```

This will compile the document and produce a `presentation.html` file alongside a `presentation_files` directory containing the necessary assets.

Alternatively, you can start a live-reloading preview server, which is very useful if you are actively editing the `presentation.qmd` file:

```bash
quarto preview presentation.qmd
```

## Viewing the Presentation

*   **If you used `quarto preview`:** Quarto will automatically open your default web browser and navigate to the local preview URL (usually `http://localhost:XXXX`).
*   **If you used `quarto render`:** Simply open the generated `presentation.html` file in any modern web browser (e.g., double-click the file in your file explorer, or drag and drop it into a browser tab).

## Talk Summary

This presentation explores the properties, structural theorems, and algorithmic challenges associated with **geometric intersection graphs**—graphs that are not strictly planar but possess structured, "almost-planar" characteristics (e.g., string graphs, disk intersection graphs, low-density graphs).

Key topics covered include:

*   **Geometric Intersection Graphs:** An introduction to graphs formed by intersecting geometric objects. The talk emphasizes why they behave better than general dense graphs in terms of computational complexity, allowing for better approximation algorithms.
*   **Algorithmic Challenges (Independent Set):** Discussion on the problem of computing maximum independent sets in these graphs, exploring existing approximation algorithms (QPTAS, constant-factor approximations), and the open challenge of discovering a PTAS (Polynomial-Time Approximation Scheme).
*   **Planar Graphs & Circle Packing:** An in-depth look at the Koebe-Andreev-Thurston circle packing theorem and primal-dual disk representations. It illustrates step-by-step how these geometric concepts inherently lead to the **Planar Separator Theorem**.
*   **Low Density & Polynomial Expansion Graphs:** Examination of graphs defined by low-density objects, their large clique minors, and their relationship with polynomial expansion graphs. These graph classes safely generalize planar graph properties, guaranteeing properties like sublinear hereditary separators.
*   **Approximation Algorithms Frameworks:** Techniques utilizing local search and recursive separators ($b$-divisions) to design efficient approximation schemes for these rich graph classes.
*   **Open Questions:** The talk concludes with pointers to recent results on string graphs (e.g., Erdős–Hajnal properties, distortion numbers) and highlights open research questions regarding the combinatorial recognition and algorithmic processing of low-density geometric graphs.
