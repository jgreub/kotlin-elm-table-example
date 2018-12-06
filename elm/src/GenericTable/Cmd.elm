module GenericTable.Cmd exposing (getData)

import GenericTable.Core exposing (Page, QueryOptions, Filter, Sort, SortDirection(..))

import Http
import Url
import Json.Decode as JD

getData : (Result Http.Error (Page a) -> msg) -> String -> QueryOptions -> (JD.Decoder a) -> Cmd msg
getData dataMsg baseDataUrl queryOptions dataDecoder =
  let
    queryParamsString = getQueryParamsString queryOptions
    completeUrl =
      if String.isEmpty queryParamsString then
        baseDataUrl
      else
        baseDataUrl ++ "?" ++ queryParamsString
  in
    Http.send dataMsg (Http.get completeUrl (pageDecoder dataDecoder))

-- Filter -> ?<prop>=<value>, Sort -> ?sort=<prop>,<asc|desc>
-- Size -> ?size=<num>, Page -> ?page=<0-index>
getQueryParamsString : QueryOptions -> String
getQueryParamsString queryOptions =
  let
    filterQueryParams = List.map (\f -> (Url.percentEncode f.name) ++ "=" ++ (Url.percentEncode f.value)) queryOptions.filters
    sortQueryParam = getSortQueryParamString queryOptions.sort
  in
    String.join "&" (List.append filterQueryParams sortQueryParam)

getSortQueryParamString : Maybe Sort -> List String
getSortQueryParamString sort =
  case sort of
    Just activeSort ->
      let
        direction =
          if activeSort.direction == ASC then
            "asc"
          else
            "desc"
      in
        [ "sort=" ++ (Url.percentEncode activeSort.name) ++ "," ++ direction ]

    Nothing ->
      []

pageDecoder : (JD.Decoder a) -> JD.Decoder (Page a)
pageDecoder dataDecoder =
    JD.map Page
      (JD.field "content" (JD.list dataDecoder))
