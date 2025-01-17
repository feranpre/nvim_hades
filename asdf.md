
```python
```python
{verbatim}
#los comentarios se ponen con el simbolo de almohadilla

#este es un comentario de una sola linea

#Para coemntarios de varias lineas se usa triple comilla doble

Este es un comentario de varias lineas

```
```
Instalamos las librerias necesarias
en jupyter notebook se instalan con el simbolo  %pip

```python
%pip install pandas
```

```python

#Importamos la libreria pandas y la renombramos como pd
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
#de la libreria scipy importamos stats
from scipy import stats

# Cargar un conjunto de datos
data = sns.load_dataset('iris')

# Descripción estadística básica
print(data.describe())

# Visualización de datos
sns.pairplot(data, hue='species')
plt.show()

# Prueba t de Student
species_a = data[data['species'] == 'setosa']['sepal_length']
species_b = data[data['species'] == 'versicolor']['sepal_length']
t_stat, p_value = stats.ttest_ind(species_a, species_b)

# Imprimir resultados
# El f-string es una forma de formatear cadenas de texto en Python
print(f"T-statistic: {t_stat}, P-value: {p_value}")

```
