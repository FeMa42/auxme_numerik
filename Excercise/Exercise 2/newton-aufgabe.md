# Programmieraufgabe: Implementierung des Newton-Verfahrens

## Einführung
Das Newton-Verfahren ist ein fundamentales numerisches Verfahren zur Bestimmung von Nullstellen nichtlinearer Funktionen. Im Gegensatz zum einfacheren Bisektionsverfahren konvergiert das Newton-Verfahren bei geeigneten Voraussetzungen quadratisch, was es besonders effizient macht.

## Abgabeformat
- Ein Julia-Notebook (.ipynb) mit eurem Code, Tests und Visualisierungen
- Dokumentiert eure Implementierung und Ergebnisse
- Meldet euch wenn ihr die Aufgabe gelöst habt bei mir

## Aufgabenstellung

Nutzt als erste Testgleichungen die folgenden Funktionen:

$$f(x) = -26 + 85 * x - 91 * x^2 + 44 * x^3 - 8 * x^4 + x^5$$
$$f'(x) = 85 - 182 * x + 132 * x^2 - 32 * x^3 + 5 * x^4$$

### Teil 1: Grundlegende Implementierung
Implementieren Sie das Newton-Verfahren in Julia. Eure Funktion sollte folgendermaßen aussehen:

```julia
function newton(f, df, x0, tol, max_iter)
    # f: Funktion, deren Nullstelle gesucht wird
    # df: Ableitung von f
    # x0: Startwert
    # tol: Toleranz (Abbruchkriterium)
    # max_iter: Maximale Anzahl an Iterationen
    
    # Implementieren Sie hier das Newton-Verfahren
    # ...
    
    # Rückgabe: Approximierte Nullstelle und Anzahl der benötigten Iterationen
end
```

Die Iteration des Newton-Verfahrens folgt der Formel:
$$x_{n+1} = x_n - \frac{f(x_n)}{f'(x_n)}$$

Ihr Code sollte:
- Die Iteration gemäß der Newton-Formel durchführen
- Abbrechen, wenn |f(x)| < tol erreicht ist
- Abbrechen, wenn die maximale Iterationszahl erreicht ist
- Die gefundene Näherung für die Nullstelle und die Anzahl der benötigten Iterationen zurückgeben

Implementiert die Funktion `newton` und testet diese mit den oben definierten Funktionen.
Beim Testen könnt ihr `tol = 0.0001` für die Toleranz verwenden.

### Teil 2: Automatische Differentiation 
Erweitern Eure Implementierung, um die manuelle Eingabe der Ableitung überflüssig zu machen. Verwenden Sie dazu das Package `TaylorSeries` in Julia, um die Ableitung automatisch zu berechnen.

```julia
function newton_auto(f, x0, tol, max_iter)
    # Implementierung mit automatischer Differentiation
    # ...
end
```

#### Hilfestellung

Wir können mit dem Package `TaylorSeries` die Ableitung berechnen. Hier ein Beispielaufruf. 
````julia
using TaylorSeries
func = x -> sin(x)
x = 1.0
TS = Taylor1(Float64, 1)   # Taylor-Polynom 1. Grades um x_0=0
dfunc = func(TS)           # Ableitung des Taylor-Polynoms 
df_x = dfunc.(x)           # Auswertung der Ableitung an x
````
Hier wird dann das Taylorpolynom an der Stelle $x_0=0$ berechnet. Wir können das Polynom auch an einer anderen Stelle auswerten. Hierfür können wir taylor_expand nutzen. 

````julia
func_t = taylor_expand(func, a, order=1)  # Taylor-Polynom um x_0=a
````

Mithilfe von differentiate können wir die Ableitung berechnen. 

````julia
dfunc_t = differentiate(func_t)
````

### Teil 3: Analyse und Tests

1. Testen Eure Implementierung an folgenden Funktionen:
   - f₁(x) = x² - 4.5          (Nullstellen in der nähe von x = ±2)
   - f₂(x) = sin(x) + 0.5x     (Nullstellen in der nähe von x = π)
   - f₃(x) = exp(x) - 2.5      (Nullstelle in der nähe von x = ln(2))
   - f₄(x) = x³ - 2x² + x - 3  (Mehrere Nullstellen mit unterschiedlichem Konvergenzverhalten)
   - f₅(x) = -26 + 85x - 91x² + 44x³ - 8x⁴ + x⁵ (komplexere Funktion)

2. Visualisiert die Funktionen und die Iterationsschritte des Newton-Verfahrens.
   - Die Funktion selbst
   - Die Iterationsschritte des Newton-Verfahrens
   
    _**Hinweis**_: 
    
    _Ändert hierfür eure `newton_auto` Funktion so ab, dass die x-Werte der Iterationsschritte mitausgegeben werden._

3. Untersucht das Konvergenzverhalten:
   - Wie hängt die Anzahl der benötigten Iterationen vom Startwert ab?
   - Gibt es Startwerte, bei denen das Verfahren nicht konvergiert?
   - Vergleichen Sie die Effizienz mit dem Bisektionsverfahren (z.B. über die Anzahl der Iterationen)

## Beispiel: Bisektion
Als Referenz hier eine Implementation des Bisektionsverfahrens:

```julia
function bisect(f, a, b, tol)
    if sign(f(a)) * sign(f(b)) >= 0
        error("Keine Nullstelle im Intervall [a,b] gefunden!")
    end
    
    c = (a + b) / 2
    iter = 0
    
    while abs(b - a) > tol
        iter += 1
        c = (a + b) / 2
        
        if f(c) == 0
            break
        elseif sign(f(a)) * sign(f(c)) < 0
            b = c
        else
            a = c
        end
    end
    
    return c, iter
end
```
