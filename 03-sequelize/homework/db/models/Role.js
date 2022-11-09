const { DataTypes } = require("sequelize");

module.exports = (sequelize) => {
  sequelize.define("Role", {
    name: {
      type: DataTypes.STRING,
      unique: true,
      allowNull: false,
    },
    description: { type: DataTypes.STRING },
  });
};

/*
name*: string (Debe ser único)
description: string
Las propiedades marcadas con asterístico son obligatorias
*/
