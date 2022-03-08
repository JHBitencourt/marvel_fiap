# Marvel FIAP

Trabalho final da disciplina de Flutter do MBA Mobile Development:

<div style="text-align: center">
    <table>
        <tr>
            <td style="text-align: center">
                <img src="https://raw.githubusercontent.com/JHBitencourt/marvel_fiap/master/gifs_readme/googleSignIn.gif" width="200"/>
      </br><b>Google Sign-In</b>
            </td>            
            <td style="text-align: center">
                <img src="https://raw.githubusercontent.com/JHBitencourt/marvel_fiap/master/gifs_readme/loginEmail.gif" width="200"/>
      </br><b>Email Sign-In</b>
            </td>
            <td style="text-align: center">
                <img src="https://raw.githubusercontent.com/JHBitencourt/marvel_fiap/master/gifs_readme/signUp.gif" width="200"/>
      </br><b>Email Sign-Up</b>
            </td>
            <td style="text-align: center">
                <img src="https://raw.githubusercontent.com/JHBitencourt/marvel_fiap/master/gifs_readme/search.gif" width="200"/>
      </br><b>Search - Infinity Loading</b>
            </td>
        </tr>
    </table>
</div>

### API

O App acessa a API disponível pela [Marvel](https://developer.marvel.com/docs) para listar e buscar os personagens do universo Marvel.

É necessário inserir a `privateKey` no arquivo `base_api.dart` enviada no `.txt` do portal da FIAP.

### APP

O app foi feito com:

- Clean Architecture;
- Bloc para gerenciamento de estados;
- GetIt como injeção de dependências;
- FirebaseAuth para autenticação;
