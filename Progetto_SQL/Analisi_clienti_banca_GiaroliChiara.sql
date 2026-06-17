select 
	cl.id_cliente,
    cl.nome,
    cl.cognome,

-- 1 ETA
timestampdiff(year, cl.data_nascita, current_date()) as eta,

-- 2 N TRANSAZIONI USCITA
count(case when tt.segno='-' then t.data else null end) as transazioni_in_uscita,

-- 3 N TRANSAZIONI IN ENTRATA
count(case when tt.segno='+' then t.data else null end) as transazioni_in_entrata,

-- 4 TOT TRANSATO IN USCITA
sum(case when tt.segno='-' then t.importo else 0 end) as tot_transato_in_uscita,

-- 5 TOT TRANSATO IN ENTRATA
sum(case when tt.segno='+' then t.importo else 0 end) as tot_transato_in_entrata,

-- 6 N TOT CONTI POSSEDUTI
count(distinct co.id_conto) as num_conti_posseduti,

-- 7 N CONTI PER TIPOLOGIA
count(distinct case when tc.desc_tipo_conto='Conto Base' then co.id_conto else null end) as num_conti_base,
count(distinct case when tc.desc_tipo_conto='Conto Business' then co.id_conto else null end) as num_conti_business,
count(distinct case when tc.desc_tipo_conto='Conto Privati' then co.id_conto else null end) as num_conti_privati,
count(distinct case when tc.desc_tipo_conto='Conto Famiglie' then co.id_conto else null end) as num_conti_famiglie,

-- 8 N TRANSAZIONI USCITA PER TIPOLOGIA CONTO
sum(case when tt.segno='-' and tc.desc_tipo_conto='Conto Base' then 1 else 0 end) as trans_uscita_base,
sum(case when tt.segno='-' and tc.desc_tipo_conto='Conto Business' then 1 else 0 end) as trans_uscita_business,
sum(case when tt.segno='-' and tc.desc_tipo_conto='Conto Privati' then 1 else 0 end) as trans_uscita_privati,
sum(case when tt.segno='-' and tc.desc_tipo_conto='Conto Famiglie' then 1 else 0 end) as trans_uscita_famiglie,

-- 9 N TRANSAZIONI ENTRATA PER TIPOLOGIA CONTO
sum(case when tt.segno='+' and tc.desc_tipo_conto='Conto Base' then 1 else 0 end) as trans_entrata_base,
sum(case when tt.segno='+' and tc.desc_tipo_conto='Conto Business' then 1 else 0 end) as trans_entrata_business,
sum(case when tt.segno='+' and tc.desc_tipo_conto='Conto Privati' then 1 else 0 end) as trans_entrata_privati,
sum(case when tt.segno='+' and tc.desc_tipo_conto='Conto Famiglie' then 1 else 0 end) as trans_entrata_famiglie,

-- 10 IMPORTO TRANSATO IN USCITA PER TIPOLOGIA CONTO
sum(case when tt.segno='-' and tc.desc_tipo_conto='Conto Base' then t.importo else 0 end) as importo_uscita_base,
sum(case when tt.segno='-' and tc.desc_tipo_conto='Conto Business' then t.importo else 0 end) as importo_uscita_business,
sum(case when tt.segno='-' and tc.desc_tipo_conto='Conto Privati' then t.importo else 0 end) as importo_uscita_privati,
sum(case when tt.segno='-' and tc.desc_tipo_conto='Conto Famiglie' then t.importo else 0 end) as importo_uscita_famiglie,

-- 11 IMPORTO TRANSATO IN ENTRATA PER TIPOLOGIA CONTO
sum(case when tt.segno='+' and tc.desc_tipo_conto='Conto Base' then t.importo else 0 end) as importo_entrata_base,
sum(case when tt.segno='+' and tc.desc_tipo_conto='Conto Business' then t.importo else 0 end) as importo_entrata_business,
sum(case when tt.segno='+' and tc.desc_tipo_conto='Conto Privati' then t.importo else 0 end) as importo_entrata_privati,
sum(case when tt.segno='+' and tc.desc_tipo_conto='Conto Famiglie' then t.importo else 0 end) as importo_entrata_famiglie

from banca.cliente cl
left join conto co on cl.id_cliente = co.id_cliente
left join tipo_conto tc on co.id_tipo_conto = tc.id_tipo_conto
left join transazioni t on co.id_conto = t.id_conto
left join tipo_transazione tt on t.id_tipo_trans = tt.id_tipo_transazione
group by 1,2,3
order by cl.id_cliente;