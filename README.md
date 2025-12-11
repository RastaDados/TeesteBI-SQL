## Teste Para Vaga de Analista de BI Jr

<h4>Por questoões éticas e de privacidade, não mencionarei o nome da empresa em que foi efetuado o teste.</h4>

<h3>Achei necessário demonstrar minhas habilidades com SQL e Banco de Dados Relacionais</h3>
<h3>OBS: Alguns dados foram modificados, por questões de privacidade, caso tenha valores divergentes, foi por isso.</h3>

Logo abaixo estará o código usando python e abiblioteca do SQL para a conexão e criação do banco de dados e as tabelas.

<br
<br>

# Respostas com SQL - Views

<hr>

<H3>Desempenho dos Vendedores por Quantidade de Vidas</H3>

<img width="889" height="763" alt="image" src="https://github.com/user-attachments/assets/33f16a07-1c15-43e2-9d56-401eb6e5b961" />

<hr>

<H3>TOP 5 Vendedores Por Supervisores</H3>

<img width="733" height="505" alt="image" src="https://github.com/user-attachments/assets/c3742d28-14e5-491c-9a42-382a423a9c2e" />

<hr>

<h3>Top 5 Supervisores por Quantidade de Vidas</h3>

<img width="428" height="216" alt="image" src="https://github.com/user-attachments/assets/6d25a311-578e-4dda-ac08-ea5566b3903f" />

<hr>

<h3>Top 5 Praças por Supervisores e Quantidade de Vidas</h3>

<img width="552" height="478" alt="image" src="https://github.com/user-attachments/assets/75bff1c3-dd72-4073-9a39-a348a4f574cd" />

<hr>

<h3>Ticket Médio por Vida</h3>

<img width="751" height="126" alt="image" src="https://github.com/user-attachments/assets/a6c90816-7f40-4ef9-9b66-b62de8798985" />

<hr>

<h3> Rank Supervisores por Tipo</h3>

<img width="635" height="224" alt="image" src="https://github.com/user-attachments/assets/8256a159-cc16-469c-a353-236b8ef14868" />

<hr>

<br>

## Código em Python para a criação do banco de dados e as tabelas.

```python
import pandas as pd
import pyodbc
from typing import Dict

# Configurações do servidor e banco de dados
server = 'DESKTOP-U56OMT1\SQLEXPRESS' 
database = 'TesteAmel'

# String de conexão com Trusted_Connection=yes
# Certifique-se de que o Driver instalado esteja correto (ex: {ODBC Driver 17 for SQL Server})
conn_string = (
    f"DRIVER={{ODBC Driver 17 for SQL Server}};"
    f"SERVER={server};"
    f"DATABASE={database};"
    f"Trusted_Connection=yes;"
)

# Estabelece a conexão
try:
    conn = pyodbc.connect(conn_string)
    cursor = conn.cursor()
    print("Conexão bem-sucedida!")

    # Exemplo de consulta (opcional)
    # cursor.execute("SELECT TOP 10 * FROM SuaTabela")
    # for row in cursor.fetchall():
    #     print(row)

except pyodbc.Error as ex:
    sqlstate = ex.args[0]
    if sqlstate == '28000':
        print("Erro de autenticação: Verifique suas permissões do Windows.")
    else:
        print(f"Ocorreu um erro na conexão: {ex}")

files_to_process: Dict[str, tuple[str, str]] = {
    'BASES TESTE ANALISTA JUNIOR AMELS.xlsx - INDIVIDUAL.csv': (
        'VENDAS_INDIVIDUAL',
        """
        Filial INT,
        Concess NVARCHAR(50),
        Cod_Vendedor INT,
        Vendedor NVARCHAR(255),
        Data DATE,
        Vidas INT,
        Qtd_Contrato INT,
        R_Adesao DECIMAL(18, 2)
        """
    ),
    'BASES TESTE ANALISTA JUNIOR AMELS.xlsx - EMPRESARIAL.csv': (
        'VENDAS_EMPRESARIAL',
        """
        Filial INT,
        Concess NVARCHAR(50),
        Cod_Vendedor INT,
        Vendedor NVARCHAR(255),
        Data DATE,
        Vidas INT,
        Qtd_Contrato INT,
        R_Adesao DECIMAL(18, 2)
        """
    ),
    'BASES TESTE ANALISTA JUNIOR AMELS.xlsx - TABELA VENDEDORES.csv': (
        'TABELA_VENDEDORES',
        """
        VENDEDOR NVARCHAR(255),
        COD_VENDEDOR INT PRIMARY KEY, -- Assumindo COD_VENDEDOR como chave primária única
        SUPERVISOR NVARCHAR(255),
        PRACA NVARCHAR(100)
        """
    )
}



#3FUNÇÕES DE CRIAÇÃO Das Tabelas


def create_table(conn: pyodbc.Connection, table_name: str, schema: str):
    """Cria a tabela no SQL Server, se ela não existir."""
    cursor = conn.cursor()
    
    # Comando T-SQL para criar a tabela. DROP TABLE é usado para garantir uma execução limpa.
    create_table_query = f"""
    IF OBJECT_ID(N'{table_name}', N'U') IS NOT NULL
        DROP TABLE {table_name};
        
    CREATE TABLE {table_name} ({schema})
    """
    
    try:
        print(f"-> Tentando criar a tabela: {table_name}...")
        cursor.execute(create_table_query)
        conn.commit()
        print(f"   [SUCESSO] Tabela '{table_name}' criada.")
    except Exception as e:
        print(f"   [ERRO] Falha ao criar a tabela {table_name}: {e}")
        # Reverte qualquer alteração se houver erro
        conn.rollback()
    finally:
        if conn:
            conn.close()
```
