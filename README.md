# Australia Land Use Summary

The land-use profile surrounding a neighbourhood is a determinant of health and associated with socioeconomic outcomes. In Australia, there is no national publicly available dataset detailing the land-use profile surrounding residential neighbourhoods. Using PostGIS a centroid was placed in every Australian Bureau of Statistics (ABS) defined Mesh Block (MB) – the smallest geographical structure in Australian geography which details the category of land-use (i.e. residential, parkland, commercial, industrial etc.). Each MB was assigned a remoteness classification and socioeconomic status, as defined by the ABS. After a buffer based on a radius of 400 metres, 1-kilometre, 2-kilometres, and 5-kilometres was calculated around each centroid, the square metre of, and the percentage of the buffer covered by, each land-use category was calculated. This dataset will support the decisions of urban planners, diverse government departments, researchers and those involved in public and environmental health.

This repository is the code used to:
1) generate the summary, in PostGIS, and
2) verify the summary, using R
