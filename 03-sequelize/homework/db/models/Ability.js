const { DataTypes } = require("sequelize");

module.exports = (sequelize) => {
  sequelize.define("Ability", {
    name: {
      type: DataTypes.STRING,
      unique: "composite.name+mana_cost",
      allowNull: false,
    },
    description: { type: DataTypes.TEXT },
    mana_cost: {
      type: DataTypes.FLOAT,
      unique: "composite.name+mana_cost",
      allowNull: false,
      validate: { min: 10.0, max: 250.0 },
    },
    summary: {
      type: DataTypes.VIRTUAL,
      get() {
        return `${this.name} (${Math.floor(
          this.mana_cost
        )} points of mana) - Description: ${this.description}`;
      },
    },
  });
};

/*
name*: string
description: text
mana_cost*: float
La combinación "name" + "mana_cost" debe ser única.
*/
