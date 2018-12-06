module GenericTable.Update exposing (updateQueryOptionsFilter, updateQueryOptionsSort)

import GenericTable.Core exposing (QueryOptions, Filter, Sort, SortDirection(..), FilterEvent, SortEvent)

updateQueryOptionsFilter : QueryOptions -> FilterEvent -> QueryOptions
updateQueryOptionsFilter queryOptions filterEvent =
  {queryOptions | filters = updateFilters queryOptions.filters filterEvent}

updateFilters : List Filter -> FilterEvent -> List Filter
updateFilters filters filterEvent =
  let
    filteredFilters = List.filter (\f -> f.name /= filterEvent.name) filters
  in
    if String.isEmpty filterEvent.value then
      filteredFilters
    else
      Filter filterEvent.name filterEvent.value :: filteredFilters

updateQueryOptionsSort : QueryOptions -> SortEvent -> QueryOptions
updateQueryOptionsSort queryOptions sortEvent =
  {queryOptions | sort = updateSort queryOptions.sort sortEvent.name}

updateSort : Maybe Sort -> String -> Maybe Sort
updateSort sort fieldName =
  case sort of
    Just existingSort ->
      updateExistingSort existingSort fieldName

    Nothing ->
      Just (Sort fieldName ASC)

updateExistingSort : Sort -> String -> Maybe Sort
updateExistingSort sort fieldName =
  if sort.name == fieldName then
    if sort.direction == ASC then
      Just (Sort fieldName DESC)
    else
      Just (Sort fieldName ASC)
  else
    Just (Sort fieldName ASC)