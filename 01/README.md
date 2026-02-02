### Задание 1

1. Изучите файл **.gitignore**. В каком terraform-файле, согласно этому .gitignore, допустимо сохранить личную, секретную информацию?(логины,пароли,ключи,токены итд)
- personal.auto.tfvars



2. Выполните код проекта. Найдите  в state-файле секретное содержимое созданного ресурса **random_password**, пришлите в качестве ответа конкретный ключ и его значение.
- "result": "j1G6GrdpwGtlDwpQ",



3. Раскомментируйте блок кода, примерно расположенный на строчках 29–42 файла main.tf. Выполните команду terraform validate. Объясните, в чём заключаются намеренно допущенные ошибки. Исправьте их.
- on main.tf line 23, in resource "docker_image": │ 23: resource "docker_image"
Не указано имя ресурса.

- on main.tf line 28, in resource "docker_container" "1nginx": | 28: resource "docker_container" "1nginx"
Ошибка в имени, такого имени нет в предыдущих блоках.

- on main.tf line 30, in resource "docker_container" "nginx": | 30:   name  = "example_${random_password.random_string_FAKE.resulT}"
Неправильно указаны random_string_FAKE, _FAKE - лишнее. А так же resulT - result.




4. Объясните своими словами, в чём может быть опасность применения ключа -auto-approve.
- Опасно: тераформ без чтения применит изменения. может удалить и пересобрать.
- Допустимо: повторное применение известных изменений, локальная разработка, ci/cd пайплайны.


5. Уничтожьте созданные ресурсы с помощью terraform. Убедитесь, что все ресурсы удалены. Приложите содержимое файла terraform.tfstate.
```
terraform destroy
```


6. Объясните, почему при этом не был удалён docker-образ nginx:latest.
причина в `keep_locally = true`, этот параметр говорит тераформу не удаляться при `terraform destroy`, а остаётся в локальном кэше.

https://library.tf/providers/kreuzwerker/docker/latest/docs/resources/image
keep_locally (Boolean) If true, then the Docker image won't be deleted on destroy operation. If this is false, it will delete the image from the docker local storage on destroy operation.


---
---
