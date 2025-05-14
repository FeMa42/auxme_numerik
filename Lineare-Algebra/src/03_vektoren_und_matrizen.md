
# Vektoren und Matrizen

## 1. Vektoren
### 1.1 Definition und Darstellung
Ein Vektor ist ein mathematisches Objekt, das sowohl eine Richtung als auch eine Länge (oder Magnitude) hat. Im Kontext der Linearen Algebra stellen wir Vektoren oft als geordnete Liste von Zahlen dar, die Komponenten genannt werden. Ein Vektor im dreidimensionalen Raum $\mathbb{R}^3$ kann beispielsweise geschrieben werden als:

$$v = \begin{bmatrix} v_1 \\ v_2 \\ v_3 \end{bmatrix}$$

Hier sind $v_1, v_2, v_3$ die Komponenten des Vektors $v$. Geometrisch kann man sich einen Vektor als Pfeil vorstellen, der vom Ursprung $(0,0,0)$ zu dem Punkt $(v_1, v_2, v_3)$ im Raum zeigt.

### 1.2 Grundlegende Vektoroperationen
**Addition:** Zwei Vektoren gleicher Dimension können addiert werden, indem ihre entsprechenden Komponenten addiert werden.
$$\begin{bmatrix} a \\ b \end{bmatrix} + \begin{bmatrix} c \\ d \end{bmatrix} = \begin{bmatrix} a+c \\ b+d \end{bmatrix}$$

**Skalare multiplikation:** \
Ein Vektor kann mit einer Zahl (Skalar) multipliziert werden, indem jede Komponente des Vektors mit diesem Skalar multipliziert wird.

$$c \begin{bmatrix} v_1 \\ v_2 \\ v_3 \end{bmatrix} = \begin{bmatrix} c \cdot v_1 \\ c \cdot v_2 \\ c \cdot v_3 \end{bmatrix}$$

Geometrisch streckt oder staucht die Skalarmultiplikation den Vektor und kann seine Richtung umkehren, wenn der Skalar negativ ist.

**Betrag:** \
Der Betrag eines Vektors $v = \begin{bmatrix} v_1 \\ v_2 \\ v_3 \end{bmatrix}$ ist definiert als die Länge des Vektors und wird berechnet als:
$$\|v\| = \sqrt{v_1^2 + v_2^2 + v_3^2}$$
Der Betrag ist immer eine nicht-negative Zahl und ist gleich Null, wenn der Vektor der Nullvektor ist.

**Skalarprodukt:**\
Das Skalarprodukt zweier Vektoren $u = \begin{bmatrix} u_1 \\ u_2 \\ u_3 \end{bmatrix}$ und $v = \begin{bmatrix} v_1 \\ v_2 \\ v_3 \end{bmatrix}$ ist definiert als:
$u \cdot v = u_1 v_1 + u_2 v_2 + u_3 v_3$

Das Skalarprodukt ist ein Maß für die Ähnlichkeit oder den Winkel zwischen zwei Vektoren. Es ist gleich Null, wenn die Vektoren orthogonal (rechtwinklig) zueinander sind.
Das Skalarprodukt kann auch verwendet werden, um den Winkel $\theta$ zwischen zwei Vektoren zu berechnen:
$u \cdot v = \|u\| \|v\| \cos(\theta)$
Hierbei ist $\|u\|$ der Betrag von $u$, $\|v\|$ der Betrag von $v$ und $\theta$ der Winkel zwischen den Vektoren.

### 1.3 Linearkombinationen
Eine Linearkombination von Vektoren $v_1, v_2, \dots, v_k$ ist ein Ausdruck der Form:

$$c_1 v_1 + c_2 v_2 + \dots + c_k v_k = b$$

wobei $c_1, c_2, \dots, c_k$ Skalare sind. Das Ergebnis $b$ ist wieder ein Vektor.

Beispiel:
Gegeben seien die Vektoren $u = \begin{bmatrix} 1 \\ -1 \\ 0 \end{bmatrix}$ und $v = \begin{bmatrix} 0 \\ 1 \\ -1 \end{bmatrix}$. 

Eine Linearkombination wäre $2u + 3v$:

$$2 \begin{bmatrix} 1 \\ -1 \\ 0 \end{bmatrix} + 3 \begin{bmatrix} 0 \\ 1 \\ -1 \end{bmatrix} = \begin{bmatrix} 2 \\ -2 \\ 0 \end{bmatrix} + \begin{bmatrix} 0 \\ 3 \\ -3 \end{bmatrix} = \begin{bmatrix} 2 \\ 1 \\ -3 \end{bmatrix}$$

Die Menge aller möglichen Linearkombinationen einer gegebenen Menge von Vektoren wird als deren Span oder lineare Hülle bezeichnet. Alle Linearkombinationen eines einzelnen Vektors (ungleich dem Nullvektor) bilden eine Gerade durch den Ursprung. Alle Linearkombinationen von zwei linear unabhängigen Vektoren bilden eine Ebene durch den Ursprung.

### 1.4 Lineare Unabhängigkeit
Eine Menge von Vektoren $v_1, \dots, v_k$ heißt linear unabhängig, wenn die einzige Linearkombination, die den Nullvektor ergibt, diejenige ist, bei der alle Skalare $c_i$ gleich Null sind:

$$c_1 v_1 + c_2 v_2 + \dots + c_k v_k = \begin{bmatrix} 0 \\ \vdots \\ 0 \end{bmatrix}$$

nur für $c_1 = c_2 = \dots = c_k = 0$. Andernfalls heißen die Vektoren linear abhängig. Das bedeutet, dass mindestens einer der Vektoren als Linearkombination der anderen ausgedrückt werden kann.

### 1.5 Basis und Dimension
Eine Basis eines Vektorraums ist eine Menge von Vektoren, die linear unabhängig sind und den gesamten Raum aufspannen. Die Dimension eines Vektorraums ist die Anzahl der Vektoren in einer Basis des Raumes. Zum Beispiel hat der Raum $\mathbb{R}^3$ die Dimension 3, da seine Basis aus drei linear unabhängigen Vektoren besteht. 
Die Dimension eines Vektorraums ist ein Maß dafür, wie viele Vektoren benötigt werden, um den Raum vollständig zu beschreiben. In $\mathbb{R}^2$ ist die Dimension 2, da zwei Vektoren benötigt werden, um jeden Punkt im Raum zu erreichen. In $\mathbb{R}^3$ ist die Dimension 3, da drei Vektoren benötigt werden, um jeden Punkt im Raum zu erreichen.


## 2. Matrizen

### 2.1 Definition und Darstellung
Unter einer $(m \times n)$-Matrix $A=(a_{ij})_{mn}$ versteht man ein rechteckiges Zahlenschema

$$A = \begin{bmatrix} a_{11} & a_{12} & \dots & a_{1n} \\ a_{21} & a_{22} & \dots & a_{2n} \\ \vdots & \vdots & \ddots & \vdots \\ a_{m1} & a_{m2} & \dots & a_{mn} \end{bmatrix}$$

wobei $m$ die Anzahl der Zeilen und $n$ die Anzahl der Spalten angibt. Die Einträge $a_{ij}$ sind die Elemente der Matrix, wobei $i$ die Zeilennummer und $j$ die Spaltennummer angibt.

**Multiplikation einer Matrix mit einem Skalar:** Eine Matrix kann mit einem Skalar multipliziert werden, indem jeder Eintrag der Matrix mit diesem Skalar multipliziert wird. Zum Beispiel:
$$ c \begin{bmatrix} a_{11} & a_{12} \\ a_{21} & a_{22} \end{bmatrix} = \begin{bmatrix} c \cdot a_{11} & c \cdot a_{12} \\ c \cdot a_{21} & c \cdot a_{22} \end{bmatrix} $$
**Addition von Matrizen:** Zwei Matrizen gleicher Dimension können addiert werden, indem ihre entsprechenden Einträge addiert werden. Zum Beispiel:
$$ \begin{bmatrix} a_{11} & a_{12} \\ a_{21} & a_{22} \end{bmatrix} + \begin{bmatrix} b_{11} & b_{12} \\ b_{21} & b_{22} \end{bmatrix} = \begin{bmatrix} a_{11}+b_{11} & a_{12}+b_{12} \\ a_{21}+b_{21} & a_{22}+b_{22} \end{bmatrix} $$

### 2.2   Transponierte Matrix

Wenn wir eine Matrix transponieren, vertauschen wir die Zeilen und Spalten. Zum Beispiel:

$$ A = \begin{bmatrix} 1 & 2 \\ 3 & 4 \end{bmatrix} $$
$$ A^T = \begin{bmatrix} 1 & 3 \\ 2 & 4 \end{bmatrix} $$

Eine Matrix ist symmetrisch, wenn $A = A^T$. Das bedeutet, dass die Matrix gleich ihrer transponierten Matrix ist. Zum Beispiel:
$$ A = \begin{bmatrix} 1 & 2 \\ 2 & 3 \end{bmatrix} $$
$$ A^T = \begin{bmatrix} 1 & 2 \\ 2 & 3 \end{bmatrix} $$

Für eine beliebige Matrix $A$ gilt, dass das produkt $A^TA$ immer eine symmetrische Matrix ist. Das bedeutet, wir können eine quadratische und symmetrische Matrix $B$ definieren als $B = A^TA$. 

### 2.3 Matrix-Vektor-Produkt
Das Produkt einer $m \times n$ Matrix $A$ und eines n-dimensionalen Spaltenvektors $x$ ist ein m-dimensionaler Spaltenvektor $b$. Es gibt zwei gängige Wege, dieses Produkt zu berechnen:

Zeilenweise (Skalarprodukt): Jede Komponente des Ergebnisvektors $b$ ist das Skalarprodukt (dot product) der entsprechenden Zeile von $A$ mit dem Vektor $x$.
$b_i = (\text{Zeile } i \text{ von } A) \cdot x$

Spaltenweise (Linearkombination): Der Ergebnisvektor $Ax$ ist eine Linearkombination der Spaltenvektoren von $A$, wobei die Komponenten von $x$ als Koeffizienten dienen.

Beispiel:
$A = \begin{bmatrix} 2 & -1 \\ -1 & 2 \end{bmatrix}, x = \begin{bmatrix} 1 \\ 2 \end{bmatrix}$

Spaltenweise:
$$Ax = 1 \begin{bmatrix} 2 \\ -1 \end{bmatrix} + 2 \begin{bmatrix} -1 \\ 2 \end{bmatrix} = \begin{bmatrix} 2 \\ -1 \end{bmatrix} + \begin{bmatrix} -2 \\ 4 \end{bmatrix} = \begin{bmatrix} 0 \\ 3 \end{bmatrix}$$

Zeilenweise:
$$Ax = \begin{bmatrix} (2 \cdot 1) + (-1 \cdot 2) \\ (-1 \cdot 1) + (2 \cdot 2) \end{bmatrix} = \begin{bmatrix} 2 - 2 \\ -1 + 4 \end{bmatrix} = \begin{bmatrix} 0 \\ 3 \end{bmatrix}$$

Die spaltenweise Sichtweise ist fundamental: Das Produkt $Ax$ ist eine Linearkombination der Spalten von $A$.

### 2.4 Multiplikation von Matrizen

Sei $A$ eine $m \times n$ Matrix und $B$ eine $n \times p$ Matrix, dann ist das Produkt $AB$ eine $m \times p$ Matrix. Die Einträge des Produkts werden durch die Zeilen von $A$ und die Spalten von $B$ bestimmt.
Die Einträge des Produkts $C = AB$ sind gegeben durch:
$$ c_{ij} = \sum_{k=1}^{n} a_{ik} b_{kj} $$
Das bedeutet, dass der Eintrag in der $i$-ten Zeile und $j$-ten Spalte von $C$ das Skalarprodukt der $i$-ten Zeile von $A$ und der $j$-ten Spalte von $B$ ist. Das Produkt $AB$ ist nur definiert, wenn die Anzahl der Spalten von $A$ gleich der Anzahl der Zeilen von $B$ ist.

Rechenregeln für Matrizen:
1. Assoziativität: $(AB)C = A(BC)$
2. Distributivität: $A(B + C) = AB + AC$
3. Im Allgemeinen gilt $AB \neq BA$ (auch wenn $A$ und $B$ quadratisch sind). Allerdings gilt: $(AB)^T = B^TA^T$
4. Das Produkt einer Matrix mit der Einheitsmatrix ergibt die Matrix selbst: $AI = A$ und $IA = A$.


### 2.5 Matrizen und Lineare Gleichungssysteme
Ein System von $m$ linearen Gleichungen mit $n$ Unbekannten kann kompakt als Matrixgleichung $Ax = b$ geschrieben werden.

Beispiel: Das Gleichungssystem
$$ 2x - y = 0 $$
$$ -x + 2y = 3 $$

kann geschrieben werden als:
$$ \begin{bmatrix} 2 & -1 \\ -1 & 2 \end{bmatrix} \begin{bmatrix} x \\ y \end{bmatrix} = \begin{bmatrix} 0 \\ 3 \end{bmatrix} $$

Hier ist $A = \begin{bmatrix} 2 & -1 \\ -1 & 2 \end{bmatrix}$ die Koeffizientenmatrix, $x = \begin{bmatrix} x \\ y \end{bmatrix}$ der Vektor der Unbekannten und $b = \begin{bmatrix} 0 \\ 3 \end{bmatrix}$ der Vektor der rechten Seiten.

Bedeutung von $Ax = b$:

Zeilenbild (Row Picture): Jede Zeile der Matrixgleichung repräsentiert eine Gleichung. Die Lösung des Systems ist der Schnittpunkt der durch die Gleichungen definierten Geraden (im 2D-Fall) oder Ebenen (im 3D-Fall). Für das Beispiel oben ist die Lösung der Schnittpunkt der Geraden $2x - y = 0$ und $-x + 2y = 3$.

Spaltenbild (Column Picture): Die Gleichung $Ax = b$ fragt: Welche Linearkombination der Spalten von $A$ ergibt den Vektor $b$? Für das Beispiel: Finde $x$ und $y$, sodass 
$$x \begin{bmatrix} 2 \\ -1 \end{bmatrix} + y \begin{bmatrix} -1 \\ 2 \end{bmatrix} = \begin{bmatrix} 0 \\ 3 \end{bmatrix}.$$

Das System $Ax=b$ hat genau dann eine Lösung für jeden Vektor $b$, wenn die Spalten von $A$ linear unabhängig sind und den gesamten Zielraum aufspannen (für eine quadratische Matrix $A$ bedeutet dies, dass $A$ invertierbar ist). Wenn die Spalten linear abhängig sind, dann ist $A$ singulär, und $Ax=b$ hat nur dann Lösungen, wenn $b$ im Spaltenraum von $A$ liegt (d.h., wenn $b$ eine Linearkombination der Spalten von $A$ ist).

### 2.6 Inverse Matrix
Für quadrahtische Matrizen (d.h. die gleiche Anzahl von Zeilen und Spalten hat) gibt es die Möglichkeit zu betrachtet ob die inverse Matrix $A^{-1}$ existiert. Wenn die inverse Matrix mit der ursprünglichen Matrix multipliziert wird ergibt dies die Einheitsmatrix. Das bedeutet, dass $A^{-1}A = I$, wobei $I$ die Einheitsmatrix ist.
Die Einheitsmatrix ist definiert als Matrix, die auf der Hauptdiagonalen Einsen und sonst Nullen hat. Zum Beispiel ist die Einheitsmatrix $I$ in zwei Dimensionen:

$$ I = \begin{bmatrix} 1 & 0 \\ 0 & 1 \end{bmatrix} $$

Die Einheitsmatrix hat die Eigenschaft, dass sie bei der Matrixmultiplikation wie die Zahl 1 wirkt. Das bedeutet, dass $AI = A$ und $IA = A$ für jede Matrix $A$ gilt.

Die Inverse einer Matrix formt die Gleichung $Ax = b$ in die Form $x = A^{-1}b$ um. Diese Umformung ist nicht immer möglich, da nicht jede Matrix eine Inverse hat. Wenn eine Matrix keine Inverse hat, ist sie singulär und das Gleichungssystem hat entweder keine Lösung oder unendlich viele Lösungen. Das bedeutet, dass die Zeilen der Matrix linear abhängig sind.

Rechenregeln für die Inverse:
1. $(AB)^{-1} = B^{-1}A^{-1}$ (Reihenfolge umkehren)
2. $(A^T)^{-1} = (A^{-1})^T$
3. $(A^{-1})^{-1} = A$ (Die Inverse der Inversen ist die Matrix selbst)

### 2.7 Determinante

Um zu entscheiden ob eine quadratische Matrix invertierbar ist oder nicht, können wir die Determinante verwenden. Die Determinante einer Matrix ist ein Skalarwert, der einige Eigenschaften der Matrix beschreibt. Eine Matrix ist genau dann invertierbar, wenn ihre Determinante ungleich Null ist. 

**Determinante einer $2 \times 2$ Matrix:**
Für eine $2 \times 2$ Matrix $A = \begin{bmatrix} a & b \\ c & d \end{bmatrix}$ ist die Determinante gegeben durch:
$$ \text{det}(A) = ad - bc $$

und wird auch zweireihige Determinante genannt. Für größere Matrizen ist die Berechnung der Determinante aufwendiger und erfolgt durch Methoden wie den Entwicklungssatz nach Laplace: 
$$ \text{det}(A) = \sum_{j=1}^{n} (-1)^{i+j} a_{ij} \text{det}(A_{ij}) $$
wobei $A_{ij}$ die Matrix ist, die entsteht, wenn die $i$-te Zeile und die $j$-te Spalte von $A$ entfernt werden. 

**Beispiel:**\
Für die $3 \times 3$ Matrix: 

$$ A = \begin{bmatrix} 2 & 3 & 5 \\ 0 & 4 & 1 \\ 1 & -2 & 0 \end{bmatrix} $$

$$ \text{det}(A) = 2 \cdot \text{det} \begin{bmatrix} 4 & 1 \\ -2 & 0 \end{bmatrix} - 3 \cdot \text{det} \begin{bmatrix} 0 & 1 \\ 1 & 0 \end{bmatrix} + 5 \cdot \text{det} \begin{bmatrix} 0 & 4 \\ 1 & -2 \end{bmatrix} $$

Alernativ kann man die Determinante durch Entwicklung nach der zweiten Zeile berechnen:

$$ \text{det}(A) = (-1) \cdot 0 \cdot \text{det} \begin{bmatrix} 3 & 5 \\ -2 & 0 \end{bmatrix} + 4 \cdot \text{det} \begin{bmatrix} 2 & 5 \\ 1 & 0 \end{bmatrix} + (-1) \cdot (1) \cdot \text{det} \begin{bmatrix} 2 & 3 \\ 1 & -2 \end{bmatrix} \\
= 4 \cdot (-5) + (-1) \cdot (-7) = -13$$

**Eigenschaften:**\\
Der Wert einer Determinante ändert sich nicht, wenn wir die Zeilen oder Spalten vertauschen: 
$$ \text{det}(A) = \text{det}(A^T) $$
Allerdings ändert sich das Vorzeichen der Determinante, wenn wir eine Zeile oder Spalte mit einer anderen vertauschen. Wenn wir eine Zeile oder Spalte mit einem Skalar multiplizieren, wird die Determinante ebenfalls mit diesem Skalar multipliziert. Wenn wir eine Zeile oder Spalte addieren, bleibt die Determinante unverändert.
Für zwei Matrizen $A$ und $B$ gilt:
$$ \text{det}(AB) = \text{det}(A) \cdot \text{det}(B) $$

Ist die Matrix $A$ invertierbar, gilt auch: 
$$ \text{det}(A^{-1}) = \frac{1}{\text{det}(A)} $$

**Rang einer Matrix**

- Für eine $m \times n$ Matrix $A$ bezeichnet man die Menge aller Lösungen des linearen Gleichungssystems $Ax = 0$ als Kern oder Nullraum von $A$. 

- Die Menge der Vektoren $Ax$, $x \in \mathbb{R}^n$ wird als wird als Spaltenraum von $A$ bezeichnet.

- Die maximale Anzahl linear unabhängiger Spalten von $A$ heißt Spaltenrang von $A$.

- Die maximale Anzahl linear unabhängiger Zeilen von $A$ heißt Zeilenrang von $A$.

- Der Rang einer Matrix ist die Dimension des Spaltenraums und ist gleich der Dimension des Zeilenraums. Der Rang einer Matrix ist immer kleiner oder gleich der Anzahl der Zeilen oder Spalten der Matrix. 

$$ \text{Rang}(A) = \text{Spaltenrang}(A) = \text{Zeilenrang}(A) \leq \min(m,n) $$
- Elementare Zeilen- und Spaltenoperationen ändern den Rang der Matrix nicht. 

**Lösbarkeit von linearen Gleichungssystemen:** \\
Das lineare Gleichungssystem $Ax = b$ hat genau dann eine Lösung, wenn der Rang der Matrix $A$ gleich dem Rang der erweiterten Matrix $[A|b]$ ist:
$$ \text{Rang}(A) = \text{Rang}([A|b]) $$

- Wenn der Rang von $A$ gleich der Anzahl der Unbekannten ist, hat das System genau eine Lösung.

- Für quadratische Matrizen ist das System genau dann lösbar, wenn die Determinante der Matrix ungleich Null ist.

### 2.8 Matrixnormen
Die Norm einer Matrix ist ein Maß für die Größe oder den Betrag der Matrix. Es gibt verschiedene Arten von Matrixnormen, die in der linearen Algebra verwendet werden. Hier sind einige gängige Matrixnormen:

- **Frobeniusnorm:** Die Frobeniusnorm einer Matrix $A$ ist definiert als die Quadratwurzel der Summe der Quadrate aller Elemente der Matrix:
$$ \|A\|_F = \sqrt{\sum_{i=1}^{m} \sum_{j=1}^{n} |a_{ij}|^2} $$

- **1-Norm:** Die 1-Norm einer Matrix $A$ ist definiert als die maximale absolute Spaltensumme:
$$ \|A\|_1 = \max_{1 \leq j \leq n} \sum_{i=1}^{m} |a_{ij}| $$

- **$\infty$-Norm:** Die $\infty$-Norm einer Matrix $A$ ist definiert als die maximale absolute Zeilensumme:
$$ \|A\|_\infty = \max_{1 \leq i \leq m} \sum_{j=1}^{n} |a_{ij}| $$
Die Norm einer Matrix ist nützlich, um die Stabilität und Konvergenz von Algorithmen in der linearen Algebra zu analysieren. Sie kann auch verwendet werden, um den Abstand zwischen Matrizen zu messen und die Sensitivität von Lösungen gegenüber Änderungen in den Eingabewerten zu bewerten.

## 3. Eigenwerte und Eigenvektoren

Sei $A$ eine $n \times n$ Matrix und $v$ ein $n$-dimensionaler Vektor $v \neq 0$. Dann ist $v$ ein Eigenvektor von $A$, wenn es eine komplexe Zahl $\lambda$ gibt mit
$$ Av = \lambda v $$
Die Zahl $\lambda$ wird als Eigenwert von $A$ bezeichnet.
Die Eigenwerte und Eigenvektoren einer Matrix sind wichtig, weil sie Informationen über die Eigenschaften der Matrix liefern. Sie sind besonders nützlich in Anwendungen wie der Hauptkomponentenanalyse (PCA) und der Stabilitätsanalyse von Differentialgleichungssystemen. 
Wir können die Eigenwerte einer Matrix finden, indem wir die charakteristische Gleichung lösen:
$$ \text{det}(A - \lambda I) = 0 $$
Hierbei ist $I$ die Einheitsmatrix. Die Lösungen $\lambda$ dieser Gleichung sind die Eigenwerte von $A$. Das Polynom $p(\lambda) = \text{det}(A - \lambda I)$ wird charakteristisches Polynom genannt und hat den Grad $n$ (für eine $n \times n$ Matrix). Die Nullstellen des charakteristischen Polynoms sind die Eigenwerte der Matrix $A$. Für jeden Eigenwert $\lambda$ können wir den entsprechenden Eigenvektor $v$ finden, indem wir das Gleichungssystem $(A - \lambda I)v = 0$ lösen.