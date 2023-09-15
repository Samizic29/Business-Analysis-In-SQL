# Business-Analysis-In-SQL : Danny's Diner

## Oyedele Samuel

## Introduction

> This is a SQL project from Danny’s <a href="https://8weeksqlchallenge.com/case-study-1/">8weeksqlchallenge</a> Danny’s Diner is a restaurant business that sell Japanese food and who want to use his business data to help make data-driven decisions for the business.

## Problem Statement

> Danny wants to use the data to answer a few simple questions about his customers, especially about their visiting patterns, how much money they’ve spent and also which menu items are their favorite. Having this deeper connection with his customers will help him deliver a better and more personalized experience for his loyal customers.
> He plans on using these insights to help him decide whether he should expand the existing customer loyalty program - additionally he needs help to generate some basic datasets so his team can easily inspect the data without needing to use SQL.

## Datasets
Three datasets tables was provided for this project analysis.
- Sales: The `sales` table captures all `customer_id` level purchases with a corresponding `order_date` and `product_id` information for when and what menu items were ordered.
- Menu: The `menu` table maps the `product_id` to the actual `product_name` and `price` of each menu item.
- Members: The `members` table captures the `join_date` when a `customer_id` joined the beta version of the Danny’s Diner loyalty program.

## Business Questions
SQL Functions: Basic Aggregations, Windows Function, Common Table Expression, Join, etc. was used to solve this questions to uncovered business insights about the customers.
1.	What is the total amount each customer spent at the restaurant?
2.	How many days has each customer visited the restaurant?
3.	What was the first item from the menu purchased by each customer?
4.	What is the most purchased item on the menu and how many times was it purchased by all customers?
5.	Which item was the most popular for each customer?
6.	Which item was purchased first by the customer after they became a member?
7.	Which item was purchased just before the customer became a member?
8.	What is the total items and amount spent for each member before they became a member?
9.	If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
10.	In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?

## Summary of Findings
- The customer A has the highest spending amount of $76.
- The most purchased item is `ramen`. It was purchased 8 times.
- Customer B has three items with same no of purchased.
- Customer A and B spent $25 and $40 respectively before they became a member.
- Customer C was never a member but purchased items of $35.

## Tools
PostgreSQL v13

You can check out the full documentation <a href = "">here</a>
