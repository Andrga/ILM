#include "glm/vec3.hpp"
#include "glm/geometric.hpp"
#include "Film.h"
#include "Color.h"
#include "Camera.hpp"

#include <fstream>
#include <vector>

#include "Renderer.h"
#include "Scene.h"
#include "Sphere.h"

int main(void) {
	std::ofstream outFile("imagen.ppm");
	Film film(1920, 1080, outFile);

	Camera camera( film,
		glm::vec3(0, 0, 0),
		glm::vec3(0, 0, -1),
		glm::vec3(0, 1, 0),
		90
	);
	std::shared_ptr<Material> azul = std::make_shared<Material>(BLUE);
	std::shared_ptr<Material> amarillo = std::make_shared<Material>(YELLOW);
	std::shared_ptr<Material> rojo = std::make_shared<Material>(RED);
	std::shared_ptr<Sphere> obj3 =
		std::make_shared<Sphere>(glm::vec3(-1, 0, -1), 0.5, azul);
	std::shared_ptr<Sphere> obj2 =
		std::make_shared<Sphere>(glm::vec3(0, 0, -2), 1.0, amarillo);
	std::shared_ptr<Sphere> obj1 =
		std::make_shared<Sphere>(glm::vec3(1, 0, -1), 0.5, rojo);
	Scene scene;
	scene.add(obj1); scene.add(obj2); scene.add(obj3);
	Renderer renderer(&film, &camera, &scene);
	renderer.Render();
	return 0;
}
