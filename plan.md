# Plan de Desarrollo — Cebadísimos

## Estado Actual

**Motor:** Godot 4.4 (Mobile renderer)  
**Rama:** `feature/state-machine-rewrite`  
**Autores:** PDL, MagicWizard, Calasonic

### Arquitectura implementada
- **State Machine** node-based para personajes y armas
- **Autoloads:** GameState, GameManager, GlobalPlayerInfo, EffectsManager, DebugOverlay
- **Sistema de rondas:** mejor de 3, con transiciones de estado
- **Controles:** P1 (WASD + F) / P2 (Flechas + P)
- **Armas:** pistola, escopeta, pistola_2 (acoplables via Marker2D)
- **Efectos:** partículas, screen shake, hitlag, squash & stretch

### Contenido actual
| Componente | Estado |
|---|---|
| Personaje ( CharacterBody2D + StateMachine) | ✅ Funcional |
| Armas plug-and-play | ✅ Funcional |
| Selección de personaje/skin | ✅ Funcional |
| Sistema de rondas + marcador | ✅ Funcional |
| 2 niveles (level, level2) | ✅ Funcional |
| Efectos de partículas | ✅ Funcional |
| Debug overlay | ✅ Funcional |

---

## Próximos pasos

### Fase 1 — Pulido del gameplay
- [ ] Balancear daño, cooldowns y velocidades de cada arma
- [ ] Agregar frames de invulnerabilidad tras recibir daño
- [ ] Ajustar knockback según arma
- [ ] Mejorar feedback sonoro (hits, disparos, pasos)
- [ ] Animaciones de muerte por tipo de arma

### Fase 2 — Contenido nuevo
- [ ] Agregar 2-3 armas más (lanzagranadas, ametralladora, cuchillo)
- [ ] Crear 3-4 niveles nuevos con plataformas variadas
- [ ] power-ups temporales (escudo, velocidad, doble salto)
- [ ] Skins desbloqueables para cada personaje

### Fase 3 — UI/UX
- [ ] Menú principal con animación
- [ ] Pantalla de victoria con stats (daño infligido, aciertos, etc.)
- [ ] HUD mejorado (barra de vida, cooldown de arma)
- [ ] Pantalla de pausa funcional
- [ ] Transiciones de escena suaves

### Fase 4 — Multiplayer & Netcode (opcional)
- [ ] Evaluación de peer-to-peer vs rollback
- [ ] Implementar conexión online básica
- [ ] Sincronización de estado del juego

### Fase 5 — Audio & Juice
- [ ] Música por nivel
- [ ] Efectos de sonido completos
- [ ] Screen shake contextual
- [ ] Slow-motion en kills

### Fase 6 — Polish & Release
- [ ] Optimización de renders y partículas
- [ ] Build para Windows/Linux/Web
- [ ] Tester feedback loop
- [ ] itch.io page

---

## Notas técnicas

### Cómo agregar un arma (recordatorio)
1. Sprites en `sprites/armas/<nombre>/`
2. Script heredando `WeaponBase` con `_on_fire()`
3. Escena con `WeaponSprite`, `FireEffect`, markers (`MuzzlePoint`, `EjectionPoint`, `RightGripPoint`)
4. StateMachine con `Idle` y `Fire`
5. Registrar en `caja_con_arma.gd`

### Cómo agregar un estado (recordatorio)
1. Crear `scripts/state_machine/personaje/<estado>.gd` extendiendo `BaseState`
2. Override `enter()`, `exit()`, `physics_update()` (retornar nombre del próximo estado)
3. Agregar nodo hijo al StateMachine en `personaje.tscn`
4. El **primer hijo** es el estado inicial

### Estructura de archivos
```
cebadisimos/
├── docs/                    # Documentación
├── fonts/                   # Fuentes
├── Recursos/                # Assets generales
├── scenes/                  # Escenas .tscn
├── scripts/
│   ├── clases/              # Clases reutilizables
│   ├── debug/               # Debug overlay
│   ├── globals/             # Autoloads
│   ├── state_machine/       # Estados (personaje/ y weapons/)
│   └── weapons/             # WeaponBase y WeaponStats
├── sprites/                 # Sprites y texturas
├── themes/                  # Temas UI
└── project.godot
```
