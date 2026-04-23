#pragma once
#include <vector>
#include <glm/geometric.hpp>
#include "Camera.hpp"
#include "Film.h"
#include "Shape.h"
#include "World.h"

class Renderer {
public:
	Renderer(Film* film, Camera* camera, World* world);

	// que genera la escena
	void Render();

	// que devuelve el color del rayo lanzado sobre la geometria.
	Color ray_color(const Ray& r)const;

	Color shade(Ray r, ShapeIntersection hit) const;

	Film* getFilm() const { return _film; }
	Camera* getCamera() const { return _camera; }
	World* getShape() const { return _world; }

private:
	Film* _film;
	Camera* _camera;
	World* _world;
};

