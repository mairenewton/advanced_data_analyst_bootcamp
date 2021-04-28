view: products {
  sql_table_name: public.products ;;

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
        label: "Google"
        url: "http://www.google.com/search?q={{value}}"
        icon_url: "http://google.com/favicon.ico"
      }
    }

  dimension: category {
    type:  string
    sql: ${TABLE}.category;;
    link: {
      label: "Category"
      url: "/explore/ecommerce_data/inventory_items?fields=inventory_items.product_category,inventory_items.product_name,inventory_items.count&f[inventory_items.product_category]=&sorts=inventory_items.count+desc&limit=5&query_timezone=America%2FNew_York&vis=%7B%7D&filter_config=%7B%22inventory_items.product_category%22%3A%5B%7B%22type%22%3A%22%3D%22%2C%22values%22%3A%5B%7B%22constant%22%3A%22%22%7D%2C%7B%7D%5D%2C%22id%22%3A1%7D%5D%7D&origin=share-expanded"
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
