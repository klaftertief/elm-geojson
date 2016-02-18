module GeoJson.CRS (CRS) where

--import Json.Decode as Decode exposing ((:=))
--import Json.Encode as Encode


type CRS
  = Named Type
  | Linked Type


type Type
  = WGS84
