
  view: ndt_sample_derived_col {
    derived_table: {
      explore_source: order_items {
        column: order_id {}
        column: profit_margin {}
        column: total_profit {}
        column: created_month {}
      }
      distribution: "order_id"
      sortkeys: ["order_id"]
      datagroup_trigger: default
    }
    dimension: order_id {
      type: number
    }
    dimension: profit_margin {
      value_format: "#,##0.00%"
      type: number
    }
    dimension: total_profit {
      value_format: "$#,##0.00"
      type: number
    }
    dimension: created_month {
      description: "When the order was created"
      type: date_month
    }
  }
