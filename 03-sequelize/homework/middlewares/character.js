const { Router } = require("express");
const { Op, Character, Role } = require("../db");
const router = Router();

router.post("/", async (req, res) => {
  try {
    const { code, name, age, race, hp, mana, date_added } = req.body;
    if (!code || !name || !hp || !mana)
      return res.status(404).send("Falta enviar datos obligatorios");

    const newCharacter = await Character.create({
      code,
      name,
      age,
      race,
      hp,
      mana,
      date_added,
    });
    return res.status(201).json(newCharacter);
  } catch (error) {
    return res.status(404).send("Error en alguno de los datos provistos");
  }
});

router.get("/", async (req, res) => {
  const { code, name, age, race, hp, mana, date_added } = req.query;

  const where = {};
  const attributes = [];
  const condition = {};

  if (code) code === "true" ? attributes.push("code") : (where.code = code);
  if (name) name === "true" ? attributes.push("name") : (where.name = name);
  if (age) age === "true" ? attributes.push("age") : (where.age = age);
  if (race) race === "true" ? attributes.push("race") : (where.race = race);
  if (hp) hp === "true" ? attributes.push("hp") : (where.hp = hp);
  if (mana) mana === "true" ? attributes.push("mana") : (where.mana = mana);
  if (date_added)
    date_added === "true"
      ? attributes.push("date_added")
      : (where.date_added = date_added);

  condition.where = where;
  if (attributes.length) condition.attributes = attributes;

  const allCharacters = await Character.findAll(condition);
  return res.json(allCharacters);

  // const allCharacters = !race
  // ? await Character.findAll()
  // : await Character.findAll({ where: { race } });
});

router.get("/young", async (req, res) => {
  try {
    const allCharacters = await Character.findAll({
      where: { age: { [Op.lt]: 25 } },
    });

    return res.json(allCharacters);
  } catch (error) {
    return res.status(404).send(error.message);
  }
});

router.get("/roles/:code", async (req, res) => {
  try {
    const { code } = req.params;
    const character = await Character.findByPk(code, { include: Role });
    return res.json(character);
  } catch (error) {
    return res.status(404).send(error.message);
  }
});

router.get("/:code", async (req, res) => {
  const { code } = req.params;

  const characterByPk = await Character.findByPk(code);

  if (!characterByPk)
    return res
      .status(404)
      .send(`El código ${code} no corresponde a un personaje existente`);

  return res.json(characterByPk);
});

router.put("/addAbilities", async (req, res) => {
  try {
    const { codeCharacter, abilities } = req.body;
    const character = await Character.findByPk(codeCharacter);
    const promises = abilities.map((ab) => character.createAbility(ab));
    await Promise.all(promises);
    return res.send("Habilidad agregada correctamente");
  } catch (error) {
    return res.status(404).send(error.message);
  }
});

router.put("/:attribute", async (req, res) => {
  try {
    const { attribute } = req.params;
    const { value } = req.query;

    await Character.update(
      { [attribute]: value },
      {
        where: {
          [attribute]: null,
        },
      }
    );

    return res.send("Personajes actualizados");
  } catch (error) {
    return res.status(404).send(error.message);
  }
});

module.exports = router;
