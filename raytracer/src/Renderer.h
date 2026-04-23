#pragma once
#include <vector>
#include <glm/geometric.hpp>
#include "Camera.hpp"
#include "Film.h"
#include "Shape.h"

class Renderer {
public:
	Renderer(Film* film, Camera* camera, Shape* shape);

	// que genera la escena
	void Render();

	// que devuelve el color del rayo lanzado sobre la geometria.
	Color ray_color(const Ray& r)const;

	Film* getFilm() const { return _film; }
	Camera* getCamera() const { return _camera; }
	Shape* getShape() const { return _shape; }

private:
	Film* _film;
	Camera* _camera;
	Shape* _shape;
};

