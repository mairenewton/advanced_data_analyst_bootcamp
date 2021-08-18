view: products {
  sql_table_name: public.products ;;

  filter: choose_a_category_to_compare {
    type: string
    suggest_explore: inventory_items
    suggest_dimension: products.category
  }

  dimension: dymanic_category {
    type:  string
    sql:
    case when {% condition ${choose_a_category_to_compare %}
      ${category}
      {% endcondition %}
      then ${category}
      else 'All other categories' END
      ;;
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
        label: "Google"
        url: "http://www.google.com/search?q={{value}}"
        icon_url: "http://google.com/favicon.ico"
      }
      link: {
        label: "Website"
        url: "http://www.google.com/search?q={{ value | encode_uri }}"
        icon_url: "http://www.google.com/s2/favicons?domain=www.{{ value | encode_uri }}.com"
      }
    }

  dimension: category {
    type: string
    sql: ${TABLE}.category ;;
    link: {
      label: "View Category Detail"
      url: "/explore/advanced_data_analyst_bootcamp/inventory_items?fields=inventory_items.product_category,inventory_items.product_name,inventory_items.count&f[products.category]={{value | url_encode }}"
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
