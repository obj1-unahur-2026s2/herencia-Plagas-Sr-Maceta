class Elemento {
  method esBueno() = true //Booleano: Indica si el elemento es bueno para la vida
  method recibeAtaqueDe(plaga) {} //Efecto: Que produce el ataque de una plaga
}

class Hogar inherits Elemento {
  var nivelDeMugre //Numero: Nivel de mugre del hogar
  const confortQueOfrece //Numero: Cuanto confort ofrece

  method modificarNivelDeMugreEn(cantidad) {
    nivelDeMugre += cantidad
  }

  override method esBueno() = 
    nivelDeMugre / 2 <= confortQueOfrece

  override method recibeAtaqueDe(plaga) {
    self.modificarNivelDeMugreEn(plaga.nivelDeDaño())
  }
}

class Huerta inherits Elemento {
  var capacidadDeProduccion //Numero: Capacidad de produccion medida en kilos por mes
  var nivel //Numero: Nivel no fijo que determina si la Huerta es buena o no

  method modificarCapacidadDeProduccion(cantidad) {
    capacidadDeProduccion += cantidad
  }

  method cambiarNivel(nuevoNivel) {
    nivel = nuevoNivel
  }

  override method esBueno() = 
    capacidadDeProduccion > nivel

  override method recibeAtaqueDe(plaga) {
    self.modificarCapacidadDeProduccion(-plaga.nivelDeDaño()*0.1)
    if(plaga.transmiteEnfermedades()){
      self.modificarCapacidadDeProduccion(-10)
    }
  }
}

class Mascota inherits Elemento {
  var nivelDeSalud //Numero: Nivel de salud de la mascota

  method modificarNivelDeSalud(cantidad) {
    nivelDeSalud += cantidad
  }

  override method esBueno() = 
    nivelDeSalud > 250

  override method recibeAtaqueDe(plaga) {
    if(plaga.transmiteEnfermedades()){
      self.modificarNivelDeSalud(-plaga.nivelDeDaño())
    }
  }
}

class Barrio {
  const elementos = [] //Objetos: Todos los objetos que forma parte de un barrio

  method agregarElemento(nuevoElemnto) {
    elementos.add(nuevoElemnto)
  }
  method quitarElemento(elementoAQuitar) {
    elementos.remove(elementoAQuitar)
  }

  method esCopado() = 
    elementos.filter({e => e.esBueno()}).size() > 
    elementos.filter({e => !e.esBueno()}).size()
}

class Plaga {
  var poblacion //Numero: La cantidad de poblacion de la plaga

  method modificarPoblacion(cantidad) {
    poblacion += cantidad
  }

  method nivelDeDaño() = 0 //Numero: Nivel de daño comun para todas las plagas
  method transmiteEnfermedades() = poblacion >= 10
  method atacar(elemento) {
    self.modificarPoblacion(poblacion*0.1)
    elemento.recibeAtaqueDe(self)
  }
}

class Cucarachas inherits Plaga {
  var pesoPromedio //Numero: Peso promedio entre toda la poblacion de cucarachas

  method modificarPeso(cantidad) {
    pesoPromedio += cantidad
  }

  override method nivelDeDaño() = 
    poblacion/2
  override method transmiteEnfermedades() = 
    super() && pesoPromedio >= 10
  
  override method atacar(elemento) {
    self.modificarPeso(2)
    super(elemento)
  }
}

class Pulgas inherits Plaga {
  override method nivelDeDaño() = 
    poblacion*2
}

class Garrapatas inherits Plaga {
  override method nivelDeDaño() = 
    poblacion*2
  override method atacar(elemento) {
    self.modificarPoblacion(poblacion*0.2)
    elemento.recibeAtaqueDe(self)
  }
}

class Mosquitos inherits Plaga {
  override method nivelDeDaño() = poblacion
  override method transmiteEnfermedades() = 
    super() && poblacion % 3 == 0
}