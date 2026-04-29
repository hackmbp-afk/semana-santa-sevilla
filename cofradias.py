from flask import Flask, render_template, request, redirect
import mariadb
import os

# 🔥 FORZAMOS LA CARPETA templates (por si hay lío de rutas)
BASE_DIR = os.path.dirname(os.path.abspath(__file__))
TEMPLATE_DIR = os.path.join(BASE_DIR, "templates")

app = Flask(__name__, template_folder=TEMPLATE_DIR)

# ================= CONEXIÓN =================
def connection():
    return mariadb.connect(
        host="192.168.59.134", 
        user="web_user",
        password="1234",
        database="Semana_Santa",
        port=3306
    )

# ================= HOME =================
@app.route('/')
def index():
    conn = connection()
    cur = conn.cursor()

    cur.execute("SELECT COUNT(*) FROM hermandades")
    hermandades = cur.fetchone()[0]

    cur.execute("SELECT COUNT(*) FROM cofradias")
    cofradias = cur.fetchone()[0]

    cur.execute("SELECT COUNT(*) FROM pasos")
    pasos = cur.fetchone()[0]

    conn.close()

    return render_template("index.html",
                           hermandades=hermandades,
                           cofradias=cofradias,
                           pasos=pasos)

# ================= HERMANDADES =================
@app.route('/hermandades')
def hermandades():
    conn = connection()
    cur = conn.cursor()

    cur.execute("SELECT * FROM hermandades")
    data = cur.fetchall()

    conn.close()
    return render_template("hermandades.html", data=data)

@app.route('/add_hermandad', methods=['POST'])
def add_hermandad():
    conn = connection()
    cur = conn.cursor()

    cur.execute("INSERT INTO hermandades(nombre,barrio) VALUES (?,?)",
                (request.form['nombre'], request.form['barrio']))

    conn.commit()
    conn.close()
    return redirect('/hermandades')

@app.route('/delete_hermandad/<id>')
def delete_hermandad(id):
    conn = connection()
    cur = conn.cursor()

    cur.execute("DELETE FROM hermandades WHERE id=?", (id,))

    conn.commit()
    conn.close()
    return redirect('/hermandades')

@app.route('/edit_hermandad/<id>', methods=['POST'])
def edit_hermandad(id):
    conn = connection()
    cur = conn.cursor()

    cur.execute("UPDATE hermandades SET nombre=?, barrio=? WHERE id=?",
                (request.form['nombre'], request.form['barrio'], id))

    conn.commit()
    conn.close()
    return redirect('/hermandades')

@app.route('/hermandad/<id>')
def detalle_hermandad(id):
    conn = connection()
    cur = conn.cursor()

    cur.execute("SELECT * FROM hermandades WHERE id=?", (id,))
    hermandad = cur.fetchone()

    cur.execute("SELECT * FROM cofradias WHERE id_hermandad=?", (id,))
    cofradias = cur.fetchall()

    conn.close()

    return render_template("detalle_hermandad.html",
                           hermandad=hermandad,
                           cofradias=cofradias)

# ================= COFRADIAS =================
@app.route('/cofradias')
def cofradias():
    conn = connection()
    cur = conn.cursor()

    cur.execute("""
        SELECT c.id, c.nombre, c.dia_salida, h.nombre, c.id_hermandad
        FROM cofradias c
        JOIN hermandades h ON c.id_hermandad = h.id
    """)
    data = cur.fetchall()

    cur.execute("SELECT * FROM hermandades")
    hermandades = cur.fetchall()

    conn.close()
    return render_template("cofradias.html", data=data, hermandades=hermandades)

@app.route('/add_cofradia', methods=['POST'])
def add_cofradia():
    conn = connection()
    cur = conn.cursor()

    cur.execute("INSERT INTO cofradias(nombre,dia_salida,id_hermandad) VALUES (?,?,?)",
                (request.form['nombre'], request.form['dia'], request.form['hermandad']))

    conn.commit()
    conn.close()
    return redirect('/cofradias')

@app.route('/delete_cofradia/<id>')
def delete_cofradia(id):
    conn = connection()
    cur = conn.cursor()

    cur.execute("DELETE FROM cofradias WHERE id=?", (id,))

    conn.commit()
    conn.close()
    return redirect('/cofradias')

@app.route('/edit_cofradia/<id>', methods=['POST'])
def edit_cofradia(id):
    conn = connection()
    cur = conn.cursor()

    cur.execute("""
        UPDATE cofradias
        SET nombre=?, dia_salida=?, id_hermandad=?
        WHERE id=?
    """, (request.form['nombre'],
          request.form['dia'],
          request.form['hermandad'],
          id))

    conn.commit()
    conn.close()
    return redirect('/cofradias')

@app.route('/cofradia/<id>')
def detalle_cofradia(id):
    conn = connection()
    cur = conn.cursor()

    cur.execute("SELECT * FROM cofradias WHERE id=?", (id,))
    cofradia = cur.fetchone()

    cur.execute("SELECT * FROM pasos WHERE id_cofradia=?", (id,))
    pasos = cur.fetchall()

    cur.execute("SELECT * FROM recorridos WHERE id_cofradia=?", (id,))
    recorrido = cur.fetchone()

    conn.close()

    return render_template("detalle_cofradia.html",
                           cofradia=cofradia,
                           pasos=pasos,
                           recorrido=recorrido)

# ================= PASOS =================
@app.route('/pasos')
def pasos():
    conn = connection()
    cur = conn.cursor()

    cur.execute("""
        SELECT p.id, p.nombre, p.estilo, c.nombre
        FROM pasos p
        JOIN cofradias c ON p.id_cofradia = c.id
    """)
    data = cur.fetchall()

    cur.execute("SELECT * FROM cofradias")
    cofradias = cur.fetchall()

    conn.close()
    return render_template("pasos.html", data=data, cofradias=cofradias)

@app.route('/add_paso', methods=['POST'])
def add_paso():
    conn = connection()
    cur = conn.cursor()

    cur.execute("INSERT INTO pasos(nombre,estilo,id_cofradia) VALUES (?,?,?)",
                (request.form['nombre'], request.form['estilo'], request.form['cofradia']))

    conn.commit()
    conn.close()
    return redirect('/pasos')

# ================= RECORRIDOS =================
@app.route('/recorridos')
def recorridos():
    conn = connection()
    cur = conn.cursor()

    cur.execute("""
        SELECT r.id, r.descripcion, c.nombre
        FROM recorridos r
        JOIN cofradias c ON r.id_cofradia = c.id
    """)
    data = cur.fetchall()

    cur.execute("SELECT * FROM cofradias")
    cofradias = cur.fetchall()

    conn.close()
    return render_template("recorridos.html", data=data, cofradias=cofradias)

@app.route('/add_recorrido', methods=['POST'])
def add_recorrido():
    conn = connection()
    cur = conn.cursor()

    cur.execute("INSERT INTO recorridos(descripcion,id_cofradia) VALUES (?,?)",
                (request.form['descripcion'], request.form['cofradia']))

    conn.commit()
    conn.close()
    return redirect('/recorridos')

# ================= EVENTOS =================
@app.route('/eventos')
def eventos():
    conn = connection()
    cur = conn.cursor()

    cur.execute("""
        SELECT e.id, e.nombre, e.fecha, h.nombre
        FROM eventos e
        JOIN hermandades h ON e.id_hermandad = h.id
    """)
    data = cur.fetchall()

    cur.execute("SELECT * FROM hermandades")
    hermandades = cur.fetchall()

    conn.close()
    return render_template("eventos.html", data=data, hermandades=hermandades)

@app.route('/add_evento', methods=['POST'])
def add_evento():
    conn = connection()
    cur = conn.cursor()

    cur.execute("INSERT INTO eventos(nombre,fecha,id_hermandad) VALUES (?,?,?)",
                (request.form['nombre'], request.form['fecha'], request.form['hermandad']))

    conn.commit()
    conn.close()
    return redirect('/eventos')

# ================= BUSCADOR =================
@app.route('/search', methods=['GET', 'POST'])
def search():
    resultados = []

    if request.method == 'POST':
        conn = connection()
        cur = conn.cursor()

        nombre = request.form['nombre']

        cur.execute("""
            SELECT c.nombre, c.dia_salida, h.nombre
            FROM cofradias c
            JOIN hermandades h ON c.id_hermandad = h.id
            WHERE c.nombre LIKE ?
        """, ('%' + nombre + '%',))

        resultados = cur.fetchall()
        conn.close()

    return render_template("search.html", resultados=resultados)

# ================= RUN =================
if __name__ == '__main__':
    app.run(host="0.0.0.0", port=5000, debug=True)