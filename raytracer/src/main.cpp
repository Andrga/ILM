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
#include "DirectionalLight.h"
#include "PointLight.h"

int main(void) {
	std::ofstream outFile("imagen.ppm");
	Film film(800, 600, outFile);

	Camera camera( film,
		glm::vec3(0, 0, 3),
		glm::vec3(0, 0, 0),
		glm::vec3(0, 1, 0),
		60
	);
	std::shared_ptr<Material> azul = std::make_shared<Material>(BLUE);
	std::shared_ptr<Material> amarillo = std::make_shared<Material>(YELLOW);
	std::shared_ptr<Material> rojo = std::make_shared<Material>(RED);
	std::shared_ptr<Material> verde = std::make_shared<Material>(GREEN, 0.5f);

	std::shared_ptr<Sphere> obj3 =
		std::make_shared<Sphere>(glm::vec3(-2, 0, -2), 1.0, rojo);
	std::shared_ptr<Sphere> obj2 =
		std::make_shared<Sphere>(glm::vec3(0, 0, -2), 1.0, amarillo);
	std::shared_ptr<Sphere> obj1 =
		std::make_shared<Sphere>(glm::vec3(2, 0, -2), 1.0, azul);
	std::shared_ptr<Sphere> suelo =
		std::make_shared<Sphere>(glm::vec3(0, -100, -2), 99.0, verde);

	Scene scene;
	scene.addShape(obj1); scene.addShape(obj2); scene.addShape(obj3); scene.addShape(suelo);

	World world(&scene);
	std::shared_ptr<PointLight> pintLight1 = std::make_shared<PointLight>(glm::vec3(2, 2, 0), WHITE);
	world.addLight(pintLight1);
	//std::shared_ptr<PointLight> pintLight2 = std::make_shared<PointLight>(glm::vec3(-2, 2, -3), WHITE);
	//world.addLight(pintLight2);

	Renderer renderer(&film, &camera, &world);
	renderer.Render();
	return 0;
}
