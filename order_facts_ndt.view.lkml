# If necessary, uncomment the line below to include explore_source.
# include: "advanced_data_analyst_bootcamp.model.lkml"

view: order_facts_ndt {
  derived_table: {
    explore_source: order_items {
      column: order_id {}
      column: user_id { field: users.id }
      column: order_item_count {}
      column: total_revenue {}
      column: created_date { field: users.created_date }
      derived_column: order {
       sql: ROW_NUMBER () OVER (PARTITION BY user_id ORDER BY created_date) ;;
      }
    }
    datagroup_trigger: default
    sortkeys: ["id"]
    distribution: "id"
  }
  dimension: order_id {
    primary_key: yes
    type: number
  }
  dimension: order_item_count {
    type: number
  }
  dimension: total_revenue {
    value_format_name: usd
    type: number
  }
  dimension: user_id {
    type: number
    hidden: yes
  }
  dimension: created_date {
    hidden: yes
    type: date
  }
  dimension: order {
    type: number
  }
}
