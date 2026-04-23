#pragma once
#include "Shape.h"
#include "Light.h"
#include <vector>

class World {
public: 
	World(Shape* shape);

	void addLight(std::shared_ptr<Light> const& light);

	Shape* getShapeScene() const { return _shapeScene; }
	const std::vector<std::shared_ptr<Light>>& getLightVector() const { return _lights; }
private:
	Shape* _shapeScene;
	std::vector<std::shared_ptr<Light>> _lights;
};

