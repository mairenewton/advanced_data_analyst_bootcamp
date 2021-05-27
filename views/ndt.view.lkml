# If necessary, uncomment the line below to include explore_source.
# include: "advanced_data_analyst_bootcamp.model.lkml"

view: add_a_unique_name_1600887039 {
  derived_table: {
    explore_source: order_items {
      column: brand { field: products.brand }
      column: total_revenue {}
      derived_column: rank {
        sql: rank() OVER (ORDER BY total_sales desc)  ;;
      }
    }
  }
  dimension: brand {}
  dimension: total_revenue {
    value_format: "$#,##0.00"
    type: number
  }
}
