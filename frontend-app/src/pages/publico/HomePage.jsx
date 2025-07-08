import React from "react";
import { Link } from "react-router-dom";

export default function HomePage() {
  return (
    <div>
      <h1>Bienvenido al Sistema de Votación Electrónico del Grupo 5</h1>
      <nav>
        <ul>
          <li>
            <Link to="/receptor/login">Acceso para Receptores de Votos</Link>
          </li>
          <li>
            <Link to="/elector/habilitar-voto">Habilitar Voto para Elector</Link>
          </li>
          <li>
            <Link to="/resultados">Resultados Públicos de la Última Elección</Link>
          </li>
        </ul>
      </nav>
    </div>
  );
}