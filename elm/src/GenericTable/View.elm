module GenericTable.View exposing (drawTable, PropertyInfo)

import GenericTable.Core exposing (Page, FilterEvent, SortEvent)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Tuple exposing (first, second)

type alias PropertyInfo a =
  (String, a -> String)

drawTable : (FilterEvent -> msg) -> (SortEvent -> msg) -> List (PropertyInfo a) -> Page a -> Html msg
drawTable filterMsg sortMsg propertyInfo page =
  let
    propertyNames = List.map first propertyInfo
    propertyAccessors = List.map second propertyInfo

    headerRow = drawHeaderRow sortMsg propertyNames
    filterRow = drawFilterRow filterMsg propertyNames
    dataRows = List.map (\x -> drawDataRow propertyAccessors x) page.content
  in
    table [] (headerRow :: filterRow :: dataRows)

drawHeaderRow : (SortEvent -> msg) -> List String -> Html msg
drawHeaderRow sortMsg fieldNames =
  thead [ style "backgroundColor" "lightgray" ] [ tr [] (List.map (\x -> drawHeader sortMsg x) fieldNames) ]

drawHeader : (SortEvent -> msg) -> String -> Html msg
drawHeader sortMsg fieldName =
  td [ onClick (createSortMsg sortMsg fieldName) ] [text fieldName]

createSortMsg : (SortEvent -> msg) -> String -> msg
createSortMsg sortMsg fieldName =
  sortMsg (SortEvent fieldName)

drawFilterRow : (FilterEvent -> msg) -> List String -> Html msg
drawFilterRow filterMsg fieldNames =
  tr [] (List.map (\x -> drawFilter filterMsg x) fieldNames)

drawFilter : (FilterEvent -> msg) -> String -> Html msg
drawFilter filterMsg fieldName =
  td [] [ input [ onInput (createFilterMsg filterMsg fieldName), placeholder "Filter..." ] [] ]

createFilterMsg : (FilterEvent -> msg) -> String -> String -> msg
createFilterMsg filterMsg fieldName filterValue =
  filterMsg (FilterEvent fieldName filterValue)

drawDataRow : List (a -> String) -> a -> Html msg
drawDataRow accessors datum =
  tr [] (List.map (\x -> drawDataColumn x datum) accessors)

drawDataColumn : (a -> String) -> a -> Html msg
drawDataColumn accessor datum =
  td [] [text (accessor datum)]