-- criando database
create database logistic;

-- tabelas
create table orders(
	order_id varchar(50) primary key,
    order_date date,
    ship_date date,
    estimated_delivery_date date,
    customer_id varchar(50),
    state varchar(50),
    city varchar(100),
    carrier varchar(100),
    order_value decimal(10,2),
    weight_kg decimal(8,2),
    status varchar(20)
);

-- verificando dados
select count(*) as total_rows from orders;
select*from orders limit 10;

-- queries de KPI, lead_time_days te diz quantos dias levaram entre pedido e envio/entrega
Select
	order_id,
    order_date,
    ship_date,
    estimated_delivery_date,
    case when ship_date is null then null else datediff(ship_date, order_date) end as lead_time_days -- 
from orders
order by order_id;

-- Atraso em relação à data estimada.
-- Calcular quantos dias cada pedido ficou atrasado em relação à estimated_delivery_date.
select
	order_id,
    carrier,
    order_date,
    ship_date,
    estimated_delivery_date,
-- Calcula diferença em dias entre a data de entrega real e a data estimada.
-- Resultado positivo = dias de atraso; 0 = no prazo; negativo = entregue antes.
    case 
		when ship_date is null then null 
        else datediff(ship_date, estimated_delivery_date) end as days_late,
-- Classificação simples para facilitar filtros/agregações.
    case
		when ship_date is null then 'not_delivered'
        when datediff(ship_date, estimated_delivery_date) <= 0 then 'on_time'
        else 'late'
	end as delivery_status
from orders
order by order_id;

-- SLA(Service Level Agreement) % (geral) — taxa de entregas no prazo entre os entregues
-- on_time_count: número de entregas no prazo ou antecipadas
-- delivered_count: número total de entregas (ship_date NOT NULL)
-- sla_percent: porcentagem (on_time / delivered)
select
	sum(case when ship_date is not null and datediff(ship_date, estimated_delivery_date) <= 0 then 1 else 0 end) as on_time_count,
	sum(case when ship_date is not null then 1 else 0 end) as delivered_count,
	round(100*sum(case when ship_date is not null and datediff(ship_date, estimated_delivery_date) <= 0 then 1 else 0 end)
		/ nullif(sum(case when ship_date is not null then 1 else 0 end),0), 2) as sla_percent
from orders;

-- Agrupa por carrier para comparar performance.
select
	carrier,
    sum(case when ship_date is not null and datediff(ship_date, estimated_delivery_date) <= 0 then 1 else 0 end) as on_time,
    sum(case when ship_date is not null then 1 else 0 end) as delivery,
    round(100*sum(case when ship_date is not null and datediff(ship_date, estimated_delivery_date) <= 0 then 1 else 0 end)
		/ nullif(sum(case when ship_date is not null then 1 else 0 end),0), 2) as sla_pct
from orders
group by carrier 
order by sla_pct desc;

-- Pedidos por estado (volume e ticket médio)
select state, count(*) as orders, round(avg(order_value),2) as avg_order_value
from orders
group by state
order by orders desc;

-- Top clientes por receita
select customer_id, count(*) as orders_count, sum(order_value) as total_revenue
from orders
group by customer_id
order by total_revenue desc
limit 10;

-- Lead time médio por mês
select
	date_format(order_date, '%Y-%m') as month,
    round(avg(datediff(ship_date, order_date)),2) as avg_lead_time_days,
    count(*) as total_orders
from orders
where ship_date is not null
group by month
order by month;

-- Calcula days_late no CTE e reusa na seleção final, evitando repetir DATEDIFF.
with base as (
	select
    order_id,
    carrier,
    order_date,
    ship_date,
    estimated_delivery_date,
    case when ship_date is null then null else datediff(ship_date, estimated_delivery_date) end as days_late
from orders
)
select
	order_id,
    carrier,
    order_date,
    ship_date,
    estimated_delivery_date,
    days_late,
    case
		when days_late is null then 'not_delivered'
        when days_late <= 0 then 'on_time'
        else 'late'
	end as delivery_status
    from base
    order by order_id;
-- FIM (demorei pra montar esse ultimo codigo, pois fiquei testando e achei interessante isso, esta muito acima do meu conhecimento mas valeu apena!)









