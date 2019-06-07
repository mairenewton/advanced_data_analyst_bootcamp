
  view: ltv_thing {
    derived_table: {
      explore_source: users {
        column: id {}
        column: Average_LTV { field: user_facts.Average_LTV }
        column: count { field: user_facts.count }
        filters: {
          field: user_facts.Average_LTV
          value: "NOT NULL"
        }
      }
    }
    dimension: id {
      type: number
    }
    dimension: Average_LTV {
      value_format: "$#,##0.00"
      type: number
    }
    dimension: count {
      type: number
    }
  }
