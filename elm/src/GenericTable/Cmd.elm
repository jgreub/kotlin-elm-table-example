module GenericTable.Cmd exposing (getData)

import GenericTable.Core exposing (Filter)

import Http
import Url
import Json.Decode as JD

getData : (Result Http.Error a -> msg) -> String -> List Filter -> (JD.Decoder a) -> Cmd msg
getData dataMsg baseDataUrl filters decodeData =
  let
    queryParams = getFilterQueryParams filters
    completeUrl =
      if String.isEmpty queryParams then
        baseDataUrl
      else
        baseDataUrl ++ "?" ++ queryParams
  in
    Http.send dataMsg (Http.get completeUrl decodeData)

getFilterQueryParams : List Filter -> String
getFilterQueryParams filters =
  String.join "&" (List.map (\f -> (Url.percentEncode f.name) ++ "=" ++ (Url.percentEncode f.value)) filters)
