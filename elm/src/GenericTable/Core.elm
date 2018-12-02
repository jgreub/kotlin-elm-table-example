module GenericTable.Core exposing (Page, QueryOptions, Filter, Sort, SortDirection)

type alias Page a =
  { content: List a
  }

type alias QueryOptions =
  { filters: List Filter
  , sort: Maybe Sort
  }

type alias Filter =
  { name: String
  , value: String
  }

type alias Sort =
  { name: String
  , direction: SortDirection
  }

type SortDirection = ASC | DESC