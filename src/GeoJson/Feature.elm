module GeoJson.Feature (Feature, encode, decode) where

import Dict exposing (Dict)
import GeoJson.Geometry as Geometry exposing (Geometry)
import Json.Decode as Decode exposing ((:=))
import Json.Encode as Encode


type FeatureType
  = Feature Geometry StringProperties (Maybe Id)
  | FeatureM Geometry MixedProperties (Maybe Id)


type Feature
  = FT FeatureType
  | Collection (List Feature)


type alias Id =
  String


type alias Properties a =
  { model : a
  , decode : Decode.Decoder a
  , encode : a -> Encode.Value
  }


type alias StringProperties =
  Properties (Dict String String)


type StringOrNumber
  = S String
  | N Float


type alias MixedProperties =
  Properties (Dict String StringOrNumber)


encodeFeatureType : FeatureType -> Encode.Value
encodeFeatureType featureType =
  let
    encodeFeature geometry properties maybeId =
      let
        baseValues =
          [ ( "type", Encode.string "Feature" )
          , ( "geometry", Geometry.encode geometry )
          , ( "properties", properties.encode properties.model )
          ]

        allValues =
          case maybeId of
            Just id ->
              ( "id", encodeId id ) :: baseValues

            Nothing ->
              baseValues
      in
        Encode.object allValues
  in
    case featureType of
      Feature geometry properties maybeId ->
        encodeFeature geometry properties maybeId

      FeatureM geometry properties maybeId ->
        encodeFeature geometry properties maybeId


encode : Feature -> Encode.Value
encode feature =
  case feature of
    FT featureType ->
      encodeFeatureType featureType

    Collection features ->
      Encode.object
        [ ( "type", Encode.string "FeatureCollection" )
        , ( "features"
          , Encode.list (List.map encode features)
          )
        ]


encodeId : Id -> Encode.Value
encodeId id =
  Encode.string id


decode : Decode.Decoder Feature
decode =
  ("type" := Decode.string)
    |> (flip Decode.andThen) decodeType


decodeType : String -> Decode.Decoder Feature
decodeType tipe =
  case tipe of
    "Feature" ->
      Decode.object1
        FT
        (Decode.oneOf
          [ (Decode.object3
              Feature
              ("geometry" := Geometry.decode)
              ("properties" := decodeStringProperties)
              (Decode.maybe ("id" := Decode.string))
            )
          , (Decode.object3
              FeatureM
              ("geometry" := Geometry.decode)
              ("properties" := decodeMixedProperties)
              (Decode.maybe ("id" := Decode.string))
            )
          ]
        )

    "FeatureCollection" ->
      Decode.object1
        Collection
        ("features" := Decode.list decode)

    _ ->
      Decode.fail ("Feature type '" ++ tipe ++ "' not supported.")


decodeStringProperties : Decode.Decoder StringProperties
decodeStringProperties =
  Decode.object1
    (\dict ->
      { model = dict
      , decode = decodeStringDict
      , encode = encodeStringDict
      }
    )
    decodeStringDict


decodeStringDict : Decode.Decoder (Dict String String)
decodeStringDict =
  Decode.dict Decode.string


encodeStringDict : Dict String String -> Encode.Value
encodeStringDict properties =
  Encode.object
    <| List.map
        (\( key, value ) -> ( key, Encode.string value ))
        (Dict.toList properties)


decodeMixedProperties : Decode.Decoder MixedProperties
decodeMixedProperties =
  Decode.object1
    (\dict ->
      { model = dict
      , decode = decodeMixedDict
      , encode = encodeMixedDict
      }
    )
    decodeMixedDict


decodeMixedDict : Decode.Decoder (Dict String StringOrNumber)
decodeMixedDict =
  Decode.dict
    (Decode.oneOf
      [ Decode.object1 S Decode.string
      , Decode.object1 N Decode.float
      ]
    )


encodeMixedDict : Dict String StringOrNumber -> Encode.Value
encodeMixedDict properties =
  Encode.object
    <| List.map
        (\( key, value ) ->
          ( key
          , case value of
              S string ->
                Encode.string string

              N number ->
                Encode.float number
          )
        )
        (Dict.toList properties)
