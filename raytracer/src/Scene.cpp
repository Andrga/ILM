#include "Scene.h"

#include <glm/detail/func_geometric.inl>

Scene::Scene() : _shapes()
{
}

void Scene::add(std::shared_ptr<Shape> const& shape)
{
	if (shape)
		_shapes.push_back(shape);
}

bool Scene::Intersect(const Ray& ray, float tMin, float tMax) const
{
	for (std::shared_ptr<Shape> shape : _shapes)
	{
		if (shape->Intersect(ray, tMin, tMax))
			return true;
	}
	return false;
}

bool Scene::Intersect(const Ray& ray, float tMin, float tMax, ShapeIntersection& shapeIntersection) const
{
	bool hit = false;
	float distance = INFINITY;

	for (std::shared_ptr<Shape> shape : _shapes) {
		ShapeIntersection nearestPoint;
		if (shape->Intersect(ray, tMin, tMax, nearestPoint)) {
			float aux = glm::distance(ray.origin(), nearestPoint.getPoint());
			if (aux < distance) {
				distance = aux;
				shapeIntersection = nearestPoint;
				hit = true;
			}
		}
	}
	return hit;
}
