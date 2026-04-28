#include "World.h"

World::World(Shape* shape) : _shapeScene(shape){
}

void World::addLight(std::shared_ptr<Light> const& light) {
	_lights.push_back(light);
}
