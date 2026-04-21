#pragma once
#include <vector>
#include <glm/geometric.hpp>
#include "Camera.hpp"
#include "Film.h"
#include "Shape.h"

class Renderer {
public: 
	Renderer(Film* film, Camera* camera, const std::vector<Shape*>& shapes);

	// que genera la escena
	void Render();

	// que devuelve el color del rayo lanzado sobre la geometria.
	Color ray_color(const Ray& r);

	Film* getFilm() const { return _film; }
	Camera* getCamera() const { return _camera; }
	const std::vector<Shape*>& getShapesVector() const { return _shapes; }

private:
	Film* _film;
	Camera* _camera;
	std::vector<Shape*> _shapes;
};

