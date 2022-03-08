import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marvel/domain/entities/character.dart';
import 'package:marvel/presentation/bloc/auth/authentication_bloc.dart';
import 'package:marvel/presentation/bloc/auth/login_cubit.dart';
import 'package:marvel/presentation/bloc/character/character_bloc.dart';
import 'package:marvel/presentation/bloc/user/user_cubit.dart';
import 'package:marvel/ui/utils/colors.dart';
import 'package:marvel/ui/widgets/limit_width.dart';
import 'package:marvel/ui/widgets/text_input.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class HomePage extends StatelessWidget {
  const HomePage();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: MarvelColors.background,
          title: Text(
            'Personagens',
            style: GoogleFonts.bangers().copyWith(
              color: MarvelColors.white,
              fontSize: 18,
            ),
          ),
          actions: const [_Logout()],
        ),
        backgroundColor: MarvelColors.black,
        body: LimitWidth(child: _CharactersBody()),
      ),
    );
  }
}

class _Logout extends StatelessWidget {
  const _Logout();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.read<LoginCubit>().resetState();
        context.read<AuthenticationBloc>().add(const LogoutRequest());
      },
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(12),
          child: const Text(
            'LOGOUT',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}

class _CharactersBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CharacterBloc, CharacterState>(
      builder: (context, state) {
        Widget child;
        String? filter;
        if (state is ContentLoading) {
          child = const _LoadingContent();
        } else if (state is ErrorContent) {
          child = _MessageContent(message: state.message);
        } else if (state is NoContent) {
          child = _MessageContent(message: state.message);
          filter = state.filter;
        } else {
          child = _ContentCharacters(state: state as CharactersLoaded);
          filter = state.filter;
        }

        return CustomScrollView(
          slivers: [
            const _HelloUser(),
            _FixedSearchBar(
              filter: filter,
            ),
            child,
          ],
        );
      },
    );
  }
}

class _ContentCharacters extends StatelessWidget {
  const _ContentCharacters({required this.state});

  final CharactersLoaded state;

  @override
  Widget build(BuildContext context) {
    final characters = state.characters;

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          if (index >= characters.length) {
            context.read<CharacterBloc>().add(const SearchCharacters());
            return const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: SpinKitThreeBounce(
                color: MarvelColors.primary,
                size: 20,
              ),
            );
          }

          final character = characters[index];

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                child: _CharacterTile(character: character),
              ),
              if (index != characters.length)
                Divider(
                  color: MarvelColors.white.withOpacity(0.6),
                  thickness: 3,
                  height: 3,
                  indent: 180,
                  endIndent: 180,
                ),
            ],
          );
        },
        childCount:
            state.hasReachedMax ? characters.length : characters.length + 1,
      ),
    );
  }
}

class _CharacterTile extends StatelessWidget {
  const _CharacterTile({required this.character});

  final Character character;

  @override
  Widget build(BuildContext context) {
    final avatar = ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: SizedBox.fromSize(
        size: const Size(110, 120),
        child: Image.network(character.avatar.url, fit: BoxFit.cover),
      ),
    );

    final name = Text(
      character.name,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: MarvelColors.white,
      ),
    );

    final description = Text(
      character.description ?? '',
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: MarvelColors.white,
      ),
    );

    return Row(
      children: [
        avatar,
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              name,
              const SizedBox(height: 8),
              description,
            ],
          ),
        ),
      ],
    );
  }
}

class _HelloUser extends StatelessWidget {
  const _HelloUser();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        Widget child = Container();

        if (state is LoggedUserState && state.user.hasName) {
          child = Text(
            'Olá, ${state.user.name}!',
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 16,
            ),
          );
        }

        return SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
          sliver: SliverToBoxAdapter(
            child: child,
          ),
        );
      },
    );
  }
}

class _FixedSearchBar extends StatelessWidget {
  const _FixedSearchBar({this.filter});

  final String? filter;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      sliver: SliverAppBar(
        automaticallyImplyLeading: false,
        pinned: true,
        centerTitle: true,
        backgroundColor: MarvelColors.transparent,
        elevation: 0,
        titleSpacing: 0,
        title: _FixedAppBarContent(filter: filter),
      ),
    );
  }
}

class _FixedAppBarContent extends StatefulWidget {
  const _FixedAppBarContent({this.filter});

  final String? filter;

  @override
  _FixedAppBarContentState createState() => _FixedAppBarContentState();
}

class _FixedAppBarContentState extends State<_FixedAppBarContent> {
  late TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller.text.isEmpty) _controller.text = widget.filter ?? '';

    return TextInputLab(
      controller: _controller,
      borderRadius: TextInputLabBorder.circular,
      suffixIcon: MdiIcons.searchWeb,
      hintText: 'Pesquise um personagem',
      onChanged: (text) =>
          context.read<CharacterBloc>().add(TextSearchChanged(text: text)),
      keyboardType: TextInputType.text,
    );
  }
}

class _LoadingContent extends StatelessWidget {
  const _LoadingContent();

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      child: Center(
        child: Image.asset(
          'assets/graphics/gifs/loading.gif',
          fit: BoxFit.fitWidth,
          color: Colors.white.withOpacity(0.3),
          colorBlendMode: BlendMode.modulate,
          width: 120.0,
        ),
      ),
    );
  }
}

class _MessageContent extends StatelessWidget {
  const _MessageContent({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}
