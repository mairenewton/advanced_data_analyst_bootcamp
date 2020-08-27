view: products {
  sql_table_name: public.products ;;

  parameter:  field_to_select{
    type: unquoted
    allowed_value: {
      value: "category"
      label: "Category"
    }
    allowed_value: {
      value: "brand"
      label: "Brand"
    }
    allowed_value: {
      value: "department"
      label: "Department"
    }
    default_value: "department"
  }

  dimension: dynamic_column_select {
    type: string
    sql: ${TABLE}.{% parameter field_to_select %} ;;
    label_from_parameter: field_to_select
  }

  dimension: id {
    hidden:  yes
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

    dimension: brand {
      type: string
      sql: ${TABLE}.brand ;;
      link: {
        label: "Google for {{value}}"
        url: "http://www.google.com/search?q={{value|encode_uri}}"
        icon_url: "http://google.com/favicon.ico"
      }
      link: {
        label: "Marketing Dashboard"
        url: "/dashboards/9?Brand%20A={{value|encode_uri}}"
      }
    }

  dimension: category {
    type: string
    sql: ${TABLE}.category ;;
    link: {
      label: "Count of Invetory Levels"
      url: "/explore/advanced_data_analyst_bootcamp/inventory_items?fields=products.category,products.name,inventory_items.count&f[products.category]={{value|encode_uri}}&limit=500"

    }
  }

  dimension: cost {
    type: number
    sql: ${TABLE}.cost ;;
  }

  dimension: department {
    type: string
    sql: ${TABLE}.department ;;
  }

  dimension: distribution_center_id {
    type: number
    hidden: yes
    sql: ${TABLE}.distribution_center_id ;;
  }

  dimension: name {
    type: string
    sql: ${TABLE}.name ;;
  }

  dimension: retail_price {
    type: number
    value_format_name: usd
    sql: ${TABLE}.retail_price ;;
  }

  dimension: sku {
    type: string
    sql: ${TABLE}.sku ;;
  }

  measure: count {
    type: count
    drill_fields: [id, name, distribution_centers.id, distribution_centers.name, inventory_items.count]
  }
}
