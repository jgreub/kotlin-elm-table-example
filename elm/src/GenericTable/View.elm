module GenericTable.View exposing (drawTable, PropertyInfo)

import GenericTable.Core exposing (Page, Filter)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Tuple exposing (first, second)

type alias PropertyInfo a =
  (String, a -> String)

drawTable : (Filter -> msg) -> List (PropertyInfo a) -> Page a -> Html msg
drawTable filterMsg propertyInfo page =
  let
    propertyNames = List.map first propertyInfo
    propertyAccessors = List.map second propertyInfo

    headerRow = drawHeaderRow propertyNames
    filterRow = drawFilterRow filterMsg propertyNames
    dataRows = List.map (\x -> drawDataRow propertyAccessors x) page.content
  in
    table [] (headerRow :: filterRow :: dataRows)

drawHeaderRow : List String -> Html msg
drawHeaderRow names =
  thead [ style "backgroundColor" "lightgray" ] [ tr [] (List.map drawHeader names) ]

drawHeader : String -> Html msg
drawHeader name =
  td [] [text name]

drawFilterRow : (Filter -> msg) -> List String -> Html msg
drawFilterRow filterMsg filterNames =
  tr [] (List.map (\x -> drawFilter filterMsg x) filterNames)

drawFilter : (Filter -> msg) -> String -> Html msg
drawFilter filterMsg filterName =
  td [] [ input [ onInput (createOnFilterChange filterMsg filterName), placeholder "Filter..." ] [] ]

createOnFilterChange : (Filter -> msg) -> String -> String -> msg
createOnFilterChange filterMsg filterName filterValue =
  filterMsg (Filter filterName filterValue)

drawDataRow : List (a -> String) -> a -> Html msg
drawDataRow accessors datum =
  tr [] (List.map (\x -> drawDataColumn x datum) accessors)

drawDataColumn : (a -> String) -> a -> Html msg
drawDataColumn accessor datum =
  td [] [text (accessor datum)]