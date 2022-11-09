const { DataTypes } = require("sequelize");

module.exports = (sequelize) => {
  sequelize.define(
    "Character",
    {
      code: {
        type: DataTypes.STRING(5),
        primaryKey: true,
        allowNull: false,
        validate: {
          isNotHenry(code) {
            if (code.toLowerCase() === "henry")
              throw new Error("no puede ser henry");
          },
        },
      },
      name: {
        type: DataTypes.STRING,
        unique: true,
        allowNull: false,
        validate: { notIn: [["Henry", "SoyHenry", "Soy Henry"]] },
      },
      age: {
        type: DataTypes.INTEGER,
        get() {
          const value = this.getDataValue("age");
          return value ? value + " years old" : null;
        },
      },
      race: {
        type: DataTypes.ENUM(
          "Human",
          "Elf",
          "Machine",
          "Demon",
          "Animal",
          "Other"
        ),
        defaultValue: "Other",
      },
      hp: {
        type: DataTypes.FLOAT,
        allowNull: false,
      },
      mana: {
        type: DataTypes.FLOAT,
        allowNull: false,
      },
      date_added: {
        type: DataTypes.DATEONLY,
        // defaultValue: DataTypes.NOW, // UTC funciona con mySQL pero no en postgres
        defaultValue: new Date().toISOString().split("T")[0],
      },
    },
    { timestamps: false }
  );
};

/*
code*: string (Máximo 5 caracteres) [PK]
name*: string (Debe ser único)
age: integer
race: enum (Posibles valores: 'Human', 'Elf', 'Machine', 'Demon', 'Animal', 'Other')
hp*: float
mana*: float
date_added: timestamp without time
En el caso de no setear una raza ("race") por default deberían asignarle "Other" y si no damos valor para "date_added" debería tomar la fecha actual. Adicionalmente queremos quitar los timestamps automáticos de createdAt y updatedAt.
*/
