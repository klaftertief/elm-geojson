module Fixtures.Geometry (..) where

import GeoJson.Simple as GeoJson


point =
  GeoJson.point [ 12.3, 34.5 ]


multiPoint =
  GeoJson.multiPoint
    [ [ 12.3, 34.5 ]
    , [ 23.4, 4.56 ]
    ]


lineString =
  GeoJson.lineString
    [ [ 12.3, 34.5 ]
    , [ 23.4, 4.56 ]
    ]


multiLineString =
  GeoJson.multiLineString
    [ [ [ 12.3, 34.5 ]
      , [ 23.4, 4.56 ]
      ]
    , [ [ 112.3, 134.5 ]
      , [ 123.4, 14.56 ]
      ]
    ]


polygon =
  GeoJson.polygon
    [ [ [ 23.4, 4.56 ]
      , [ 12.3, 34.5 ]
      , [ 3.4, -14.56 ]
      , [ 23.4, 4.56 ]
      ]
    ]


multiPolygon =
  GeoJson.multiPolygon
    [ [ [ [ 23.4, 4.56 ]
        , [ 12.3, 34.5 ]
        , [ 3.4, -14.56 ]
        , [ 23.4, 4.56 ]
        ]
      ]
    , [ [ [ 100.2, 0.2 ]
        , [ 100.8, 0.2 ]
        , [ 100.8, 0.8 ]
        , [ 100.2, 0.8 ]
        , [ 100.2, 0.2 ]
        ]
      ]
    ]


geometryCollection =
  GeoJson.geometryCollection
    <| List.map
        GeoJson.getGeometry
        [ point
        , multiPoint
        , lineString
        , multiLineString
        , polygon
        , multiPolygon
        ]


featurePoint =
  GeoJson.feature (GeoJson.getGeometry point)


featureLineString =
  GeoJson.feature (GeoJson.getGeometry lineString)


featurePolygon =
  GeoJson.feature (GeoJson.getGeometry polygon)


featureGeometryCollection =
  GeoJson.feature (GeoJson.getGeometry geometryCollection)


featureCollection =
  GeoJson.featureCollection
    <| List.map
        GeoJson.getFeature
        [ featurePoint
        , featureLineString
        , featurePolygon
        , featureGeometryCollection
        ]
