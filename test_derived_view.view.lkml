include: "advanced_data_analyst_bootcamp.model.lkml"
view: order_facts2 {
  derived_table: {
    explore_source: order_items {
      column: order_id { field: order_id }
      column: total_revenue {}
      column: order_item_count {}
      derived_column: order_sequence {
        sql: ROW_NUMBER() OVER (PARTITION BY user_id
          ORDER BY order_created);;
      }
    }
  }
}
