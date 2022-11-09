require("dotenv").config();
const { Sequelize, Op } = require("sequelize");
const modelCharacter = require("./models/Character.js");
const modelAbility = require("./models/Ability.js");
const modelRole = require("./models/Role.js");
const { DB_USER, DB_PASSWORD, DB_HOST, DB_TIMEZONE } = process.env;
// const db = new Sequelize(
//   "postgres://usuario:clave@localhost:5432/henry_sequelize",
//   {logging: false,}
// );
const db = new Sequelize("henry_sequelize", DB_USER, DB_PASSWORD, {
  host: DB_HOST,
  dialect: "postgres",
  logging: false,
  timezone: DB_TIMEZONE,
});

modelCharacter(db);
modelAbility(db);
modelRole(db);

const { Ability, Character, Role } = db.models;

Character.hasMany(Ability);
Ability.belongsTo(Character);

Character.belongsToMany(Role, { through: "Character_Role" });
Role.belongsToMany(Character, { through: "Character_Role" });

module.exports = {
  ...db.models,
  db,
  Op,
};
