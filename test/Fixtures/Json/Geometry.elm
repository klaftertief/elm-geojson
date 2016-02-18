module Fixtures.Json.Geometry (..) where


point =
  """{"type":"Point","coordinates":[12.3,34.5]}"""


lineString =
  """
  { "type": "LineString",
    "coordinates": [ [100.0, 0.0], [101.0, 1.0] ]
  }
  """


polygon =
  """
  { "type": "Polygon",
    "coordinates": [
      [ [100.0, 0.0], [101.0, 0.0], [101.0, 1.0], [100.0, 1.0], [100.0, 0.0] ]
      ]
  }
  """


multiLineString =
  """
  { "type": "MultiLineString",
    "coordinates": [
        [ [100.0, 0.0], [101.0, 1.0] ],
        [ [102.0, 2.0], [103.0, 3.0] ]
      ]
    }
  """
