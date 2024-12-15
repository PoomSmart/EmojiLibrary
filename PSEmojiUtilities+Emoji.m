// EmojiCategory > -readEmojis:YES withVariant:NO pretty:YES
// The list of emojis per iOS-oriented category
#import "PSEmojiUtilities.h"
#import <version.h>

@implementation PSEmojiUtilities (Emoji)

+ (NSArray <NSString *> *)AsFakeSet:(NSArray <NSString *> *)array {
    if (IS_IOS_OR_NEWER(iOS_14_0))
        return (NSArray <NSString *> *)[NSOrderedSet orderedSetWithArray:array];
    return array;
}

+ (NSArray <NSString *> *)PeopleEmoji {
    static dispatch_once_t onceToken;
    static NSArray <NSString *> *data;
    dispatch_once(&onceToken, ^{
        data = [self AsFakeSet:@[
            @"😀", @"😃", @"😄", @"😁", @"😆", @"🥹", @"😅", @"😂", @"🤣", @"🥲",
            @"☺️", @"😊", @"😇", @"🙂", @"🙃", @"😉", @"😌", @"😍", @"🥰", @"😘",
            @"😗", @"😙", @"😚", @"😋", @"😛", @"😝", @"😜", @"🤪", @"🤨", @"🧐",
            @"🤓", @"😎", @"🥸", @"🤩", @"🥳", @"🙂‍↕️", @"😏", @"😒", @"🙂‍↔️", @"😞",
            @"😔", @"😟", @"😕", @"🙁", @"☹️", @"😣", @"😖", @"😫", @"😩", @"🥺",
            @"😢", @"😭", @"😤", @"😠", @"😡", @"🤬", @"🤯", @"😳", @"🥵", @"🥶",
            @"😶‍🌫️", @"😱", @"😨", @"😰", @"😥", @"😓", @"🤗", @"🤔", @"🫣", @"🤭",
            @"🫢", @"🫡", @"🤫", @"🫠", @"🤥", @"😶", @"🫥", @"😐", @"🫤", @"😑",
            @"🫨", @"😬", @"🙄", @"😯", @"😦", @"😧", @"😮", @"😲", @"🥱", @"😴",
            @"🤤", @"😪", @"😮‍💨", @"😵", @"😵‍💫", @"🤐", @"🥴", @"🤢", @"🤮", @"🤧",
            @"😷", @"🤒", @"🤕", @"🤑", @"🤠", @"😈", @"👿", @"👹", @"👺", @"🤡",
            @"💩", @"👻", @"💀", @"☠️", @"👽", @"👾", @"🤖", @"🎃", @"😺", @"😸",
            @"😹", @"😻", @"😼", @"😽", @"🙀", @"😿", @"😾", @"🫶", @"🤲", @"👐",
            @"🙌", @"👏", @"🤝", @"👍", @"👎", @"👊", @"✊", @"🤛", @"🤜", @"🫷",
            @"🫸", @"🤞", @"✌️", @"🫰", @"🤟", @"🤘", @"👌", @"🤌", @"🤏", @"🫳",
            @"🫴", @"👈", @"👉", @"👆", @"👇", @"☝️", @"✋", @"🤚", @"🖐️", @"🖖",
            @"👋", @"🤙", @"🫲", @"🫱", @"💪", @"🦾", @"🖕", @"✍️", @"🙏", @"🫵",
            @"🦶", @"🦵", @"🦿", @"💄", @"💋", @"👄", @"🫦", @"🦷", @"👅", @"👂",
            @"🦻", @"👃", @"👣", @"👁️", @"👀", @"🫀", @"🫁", @"🧠", @"🗣️", @"👤",
            @"👥", @"🫂", @"👶", @"👧", @"🧒", @"👦", @"👩", @"🧑", @"👨", @"👩‍🦱",
            @"🧑‍🦱", @"👨‍🦱", @"👩‍🦰", @"🧑‍🦰", @"👨‍🦰", @"👱‍♀️", @"👱", @"👱‍♂️", @"👩‍🦳", @"🧑‍🦳",
            @"👨‍🦳", @"👩‍🦲", @"🧑‍🦲", @"👨‍🦲", @"🧔‍♀️", @"🧔", @"🧔‍♂️", @"👵", @"🧓", @"👴",
            @"👲", @"👳‍♀️", @"👳", @"👳‍♂️", @"🧕", @"👮‍♀️", @"👮", @"👮‍♂️", @"👷‍♀️", @"👷",
            @"👷‍♂️", @"💂‍♀️", @"💂", @"💂‍♂️", @"🕵️‍♀️", @"🕵️", @"🕵️‍♂️", @"👩‍⚕️", @"🧑‍⚕️", @"👨‍⚕️",
            @"👩‍🌾", @"🧑‍🌾", @"👨‍🌾", @"👩‍🍳", @"🧑‍🍳", @"👨‍🍳", @"👩‍🎓", @"🧑‍🎓", @"👨‍🎓", @"👩‍🎤",
            @"🧑‍🎤", @"👨‍🎤", @"👩‍🏫", @"🧑‍🏫", @"👨‍🏫", @"👩‍🏭", @"🧑‍🏭", @"👨‍🏭", @"👩‍💻", @"🧑‍💻",
            @"👨‍💻", @"👩‍💼", @"🧑‍💼", @"👨‍💼", @"👩‍🔧", @"🧑‍🔧", @"👨‍🔧", @"👩‍🔬", @"🧑‍🔬", @"👨‍🔬",
            @"👩‍🎨", @"🧑‍🎨", @"👨‍🎨", @"👩‍🚒", @"🧑‍🚒", @"👨‍🚒", @"👩‍✈️", @"🧑‍✈️", @"👨‍✈️", @"👩‍🚀",
            @"🧑‍🚀", @"👨‍🚀", @"👩‍⚖️", @"🧑‍⚖️", @"👨‍⚖️", @"👰‍♀️", @"👰", @"👰‍♂️", @"🤵‍♀️", @"🤵",
            @"🤵‍♂️", @"👸", @"🫅", @"🤴", @"🥷", @"🦸‍♀️", @"🦸", @"🦸‍♂️", @"🦹‍♀️", @"🦹",
            @"🦹‍♂️", @"🤶", @"🧑‍🎄", @"🎅", @"🧙‍♀️", @"🧙", @"🧙‍♂️", @"🧝‍♀️", @"🧝", @"🧝‍♂️",
            @"🧌", @"🧛‍♀️", @"🧛", @"🧛‍♂️", @"🧟‍♀️", @"🧟", @"🧟‍♂️", @"🧞‍♀️", @"🧞", @"🧞‍♂️",
            @"🧜‍♀️", @"🧜", @"🧜‍♂️", @"🧚‍♀️", @"🧚", @"🧚‍♂️", @"👼", @"🤰", @"🫄", @"🫃",
            @"🤱", @"👩‍🍼", @"🧑‍🍼", @"👨‍🍼", @"🙇‍♀️", @"🙇", @"🙇‍♂️", @"💁‍♀️", @"💁", @"💁‍♂️",
            @"🙅‍♀️", @"🙅", @"🙅‍♂️", @"🙆‍♀️", @"🙆", @"🙆‍♂️", @"🙋‍♀️", @"🙋", @"🙋‍♂️", @"🧏‍♀️",
            @"🧏", @"🧏‍♂️", @"🤦‍♀️", @"🤦", @"🤦‍♂️", @"🤷‍♀️", @"🤷", @"🤷‍♂️", @"🙎‍♀️", @"🙎",
            @"🙎‍♂️", @"🙍‍♀️", @"🙍", @"🙍‍♂️", @"💇‍♀️", @"💇", @"💇‍♂️", @"💆‍♀️", @"💆", @"💆‍♂️",
            @"🧖‍♀️", @"🧖", @"🧖‍♂️", @"💅", @"🤳", @"💃", @"🕺", @"👯‍♀️", @"👯", @"👯‍♂️",
            @"🕴️", @"👩‍🦽", @"🧑‍🦽", @"👨‍🦽", @"👩‍🦽‍➡️", @"🧑‍🦽‍➡️", @"👨‍🦽‍➡️", @"👩‍🦼", @"🧑‍🦼", @"👨‍🦼",
            @"👩‍🦼‍➡️", @"🧑‍🦼‍➡️", @"👨‍🦼‍➡️", @"🚶‍♀️", @"🚶", @"🚶‍♂️", @"🚶‍♀️‍➡️", @"🚶‍➡️", @"🚶‍♂️‍➡️", @"👩‍🦯",
            @"🧑‍🦯", @"👨‍🦯", @"👩‍🦯‍➡️", @"🧑‍🦯‍➡️", @"👨‍🦯‍➡️", @"🧎‍♀️", @"🧎", @"🧎‍♂️", @"🏃‍♀️", @"🏃",
            @"🏃‍♂️", @"🏃‍♀️‍➡️", @"🏃‍➡️", @"🏃‍♂️‍➡️", @"🧎‍♀️‍➡️", @"🧎‍➡️", @"🧎‍♂️‍➡️", @"🧍‍♀️", @"🧍", @"🧍‍♂️",
            @"👫", @"👭", @"👬", @"👩‍❤️‍👨", @"👩‍❤️‍👩", @"💑", @"👨‍❤️‍👨", @"👩‍❤️‍💋‍👨", @"👩‍❤️‍💋‍👩", @"💏",
            @"👨‍❤️‍💋‍👨", @"🪢", @"🧶", @"🧵", @"🪡", @"🧥", @"🥼", @"🦺", @"👚", @"👕",
            @"👖", @"🩲", @"🩳", @"👔", @"👗", @"👙", @"🩱", @"👘", @"🥻", @"🩴",
            @"🥿", @"👠", @"👡", @"👢", @"👞", @"👟", @"🥾", @"🧦", @"🧤", @"🧣",
            @"🎩", @"🧢", @"👒", @"🎓", @"⛑️", @"🪖", @"👑", @"💍", @"👝", @"👛",
            @"👜", @"💼", @"🎒", @"🧳", @"👓", @"🕶️", @"🥽", @"🌂"
        ]];
    });
    return data;
}

+ (NSArray <NSString *> *)NatureEmoji {
    static dispatch_once_t onceToken;
    static NSArray <NSString *> *data;
    dispatch_once(&onceToken, ^{
        data = [self AsFakeSet:@[
            @"🐶", @"🐱", @"🐭", @"🐹", @"🐰", @"🦊", @"🐻", @"🐼", @"🐻‍❄️", @"🐨",
            @"🐯", @"🦁", @"🐮", @"🐷", @"🐽", @"🐸", @"🐵", @"🙈", @"🙉", @"🙊",
            @"🐒", @"🐔", @"🐧", @"🐦", @"🐤", @"🐣", @"🐥", @"🪿", @"🦆", @"🐦‍⬛",
            @"🦅", @"🦉", @"🦇", @"🐺", @"🐗", @"🐴", @"🦄", @"🫎", @"🐝", @"🪱",
            @"🐛", @"🦋", @"🐌", @"🐞", @"🐜", @"🪰", @"🪲", @"🪳", @"🦟", @"🦗",
            @"🕷️", @"🕸️", @"🦂", @"🐢", @"🐍", @"🦎", @"🦖", @"🦕", @"🐙", @"🦑",
            @"🪼", @"🦐", @"🦞", @"🦀", @"🐡", @"🐠", @"🐟", @"🐬", @"🐳", @"🐋",
            @"🦈", @"🦭", @"🐊", @"🐅", @"🐆", @"🦓", @"🦍", @"🦧", @"🦣", @"🐘",
            @"🦛", @"🦏", @"🐪", @"🐫", @"🦒", @"🦘", @"🦬", @"🐃", @"🐂", @"🐄",
            @"🫏", @"🐎", @"🐖", @"🐏", @"🐑", @"🦙", @"🐐", @"🦌", @"🐕", @"🐩",
            @"🦮", @"🐕‍🦺", @"🐈", @"🐈‍⬛", @"🪶", @"🪽", @"🐓", @"🦃", @"🦤", @"🦚",
            @"🦜", @"🦢", @"🦩", @"🕊️", @"🐇", @"🦝", @"🦨", @"🦡", @"🦫", @"🦦",
            @"🦥", @"🐁", @"🐀", @"🐿️", @"🦔", @"🐾", @"🐉", @"🐲", @"🐦‍🔥", @"🌵",
            @"🎄", @"🌲", @"🌳", @"🌴", @"🪵", @"🌱", @"🌿", @"☘️", @"🍀", @"🎍",
            @"🪴", @"🎋", @"🍃", @"🍂", @"🍁", @"🪺", @"🪹", @"🍄", @"🍄‍🟫", @"🐚",
            @"🪸", @"🪨", @"🌾", @"💐", @"🌷", @"🌹", @"🥀", @"🪻", @"🪷", @"🌺",
            @"🌸", @"🌼", @"🌻", @"🌞", @"🌝", @"🌛", @"🌜", @"🌚", @"🌕", @"🌖",
            @"🌗", @"🌘", @"🌑", @"🌒", @"🌓", @"🌔", @"🌙", @"🌎", @"🌍", @"🌏",
            @"🪐", @"💫", @"⭐️", @"🌟", @"✨", @"⚡️", @"☄️", @"💥", @"🔥", @"🌪️",
            @"🌈", @"☀️", @"🌤️", @"⛅️", @"🌥️", @"☁️", @"🌦️", @"🌧️", @"⛈️", @"🌩️",
            @"🌨️", @"❄️", @"☃️", @"⛄️", @"🌬️", @"💨", @"💧", @"💦", @"🫧", @"☔️",
            @"☂️", @"🌊", @"🌫️"
        ]];
    });
    return data;
}

+ (NSArray <NSString *> *)FoodAndDrinkEmoji {
    static dispatch_once_t onceToken;
    static NSArray <NSString *> *data;
    dispatch_once(&onceToken, ^{
        data = [self AsFakeSet:@[
            @"🍏", @"🍎", @"🍐", @"🍊", @"🍋", @"🍋‍🟩", @"🍌", @"🍉", @"🍇", @"🍓",
            @"🫐", @"🍈", @"🍒", @"🍑", @"🥭", @"🍍", @"🥥", @"🥝", @"🍅", @"🍆",
            @"🥑", @"🫛", @"🥦", @"🥬", @"🥒", @"🌶️", @"🫑", @"🌽", @"🥕", @"🫒",
            @"🧄", @"🧅", @"🥔", @"🍠", @"🫚", @"🥐", @"🥯", @"🍞", @"🥖", @"🥨",
            @"🧀", @"🥚", @"🍳", @"🧈", @"🥞", @"🧇", @"🥓", @"🥩", @"🍗", @"🍖",
            @"🦴", @"🌭", @"🍔", @"🍟", @"🍕", @"🫓", @"🥪", @"🥙", @"🧆", @"🌮",
            @"🌯", @"🫔", @"🥗", @"🥘", @"🫕", @"🥫", @"🫙", @"🍝", @"🍜", @"🍲",
            @"🍛", @"🍣", @"🍱", @"🥟", @"🦪", @"🍤", @"🍙", @"🍚", @"🍘", @"🍥",
            @"🥠", @"🥮", @"🍢", @"🍡", @"🍧", @"🍨", @"🍦", @"🥧", @"🧁", @"🍰",
            @"🎂", @"🍮", @"🍭", @"🍬", @"🍫", @"🍿", @"🍩", @"🍪", @"🌰", @"🥜",
            @"🫘", @"🍯", @"🥛", @"🫗", @"🍼", @"🫖", @"☕️", @"🍵", @"🧃", @"🥤",
            @"🧋", @"🍶", @"🍺", @"🍻", @"🥂", @"🍷", @"🥃", @"🍸", @"🍹", @"🧉",
            @"🍾", @"🧊", @"🥄", @"🍴", @"🍽️", @"🥣", @"🥡", @"🥢", @"🧂"
        ]];
    });
    return data;
}

+ (NSArray <NSString *> *)CelebrationEmoji {
    static dispatch_once_t onceToken;
    static NSArray <NSString *> *data;
    dispatch_once(&onceToken, ^{
        data = [self AsFakeSet:@[
            @"🎀", @"🎁", @"🎂", @"🎃", @"🎄", @"🎋", @"🎍", @"🎑", @"🎆", @"🎇",
            @"🎉", @"🎊", @"🎈", @"💫", @"✨", @"💥", @"🎓", @"👑", @"🎎", @"🎏",
            @"🎐", @"🎌", @"🏮", @"❤️", @"💔", @"💌", @"💕", @"💞", @"💓", @"💗",
            @"💖", @"💘", @"💝", @"💟", @"💜", @"💛", @"💚", @"💙", @"❣️"
        ]];
    });
    return data;
}

+ (NSArray <NSString *> *)ActivityEmoji {
    static dispatch_once_t onceToken;
    static NSArray <NSString *> *data;
    dispatch_once(&onceToken, ^{
        data = [self AsFakeSet:@[
            @"⚽️", @"🏀", @"🏈", @"⚾️", @"🥎", @"🎾", @"🏐", @"🏉", @"🥏", @"🎱",
            @"🪀", @"🏓", @"🏸", @"🏒", @"🏑", @"🥍", @"🏏", @"🪃", @"🥅", @"⛳️",
            @"🪁", @"🛝", @"🏹", @"🎣", @"🤿", @"🥊", @"🥋", @"🎽", @"🛹", @"🛼",
            @"🛷", @"⛸️", @"🥌", @"🎿", @"⛷️", @"🏂", @"🪂", @"🏋️‍♀️", @"🏋️", @"🏋️‍♂️",
            @"🤼‍♀️", @"🤼", @"🤼‍♂️", @"🤸‍♀️", @"🤸", @"🤸‍♂️", @"⛹️‍♀️", @"⛹️", @"⛹️‍♂️", @"🤺",
            @"🤾‍♀️", @"🤾", @"🤾‍♂️", @"🏌️‍♀️", @"🏌️", @"🏌️‍♂️", @"🏇", @"🧘‍♀️", @"🧘", @"🧘‍♂️",
            @"🏄‍♀️", @"🏄", @"🏄‍♂️", @"🏊‍♀️", @"🏊", @"🏊‍♂️", @"🤽‍♀️", @"🤽", @"🤽‍♂️", @"🚣‍♀️",
            @"🚣", @"🚣‍♂️", @"🧗‍♀️", @"🧗", @"🧗‍♂️", @"🚵‍♀️", @"🚵", @"🚵‍♂️", @"🚴‍♀️", @"🚴",
            @"🚴‍♂️", @"🏆", @"🥇", @"🥈", @"🥉", @"🏅", @"🎖️", @"🏵️", @"🎗️", @"🎫",
            @"🎟️", @"🎪", @"🤹‍♀️", @"🤹", @"🤹‍♂️", @"🎭", @"🩰", @"🎨", @"🎬", @"🎤",
            @"🎧", @"🎼", @"🎹", @"🪇", @"🥁", @"🪘", @"🎷", @"🎺", @"🪗", @"🎸",
            @"🪕", @"🎻", @"🪈", @"🎲", @"♟️", @"🎯", @"🎳", @"🎮", @"🎰", @"🧩"
        ]];
    });
    return data;
}

+ (NSArray <NSString *> *)TravelAndPlacesEmoji {
    static dispatch_once_t onceToken;
    static NSArray <NSString *> *data;
    dispatch_once(&onceToken, ^{
        data = [self AsFakeSet:@[
            @"🚗", @"🚕", @"🚙", @"🚌", @"🚎", @"🏎️", @"🚓", @"🚑", @"🚒", @"🚐",
            @"🛻", @"🚚", @"🚛", @"🚜", @"🦯", @"🦽", @"🦼", @"🩼", @"🛴", @"🚲",
            @"🛵", @"🏍️", @"🛺", @"🛞", @"🚨", @"🚔", @"🚍", @"🚘", @"🚖", @"🚡",
            @"🚠", @"🚟", @"🚃", @"🚋", @"🚞", @"🚝", @"🚄", @"🚅", @"🚈", @"🚂",
            @"🚆", @"🚇", @"🚊", @"🚉", @"✈️", @"🛫", @"🛬", @"🛩️", @"💺", @"🛰️",
            @"🚀", @"🛸", @"🚁", @"🛶", @"⛵️", @"🚤", @"🛥️", @"🛳️", @"⛴️", @"🚢",
            @"🛟", @"⚓️", @"🪝", @"⛽️", @"🚧", @"🚦", @"🚥", @"🚏", @"🗺️", @"🗿",
            @"🗽", @"🗼", @"🏰", @"🏯", @"🏟️", @"🎡", @"🎢", @"🎠", @"⛲️", @"⛱️",
            @"🏖️", @"🏝️", @"🏜️", @"🌋", @"⛰️", @"🏔️", @"🗻", @"🏕️", @"⛺️", @"🛖",
            @"🏠", @"🏡", @"🏘️", @"🏚️", @"🏗️", @"🏭", @"🏢", @"🏬", @"🏣", @"🏤",
            @"🏥", @"🏦", @"🏨", @"🏪", @"🏫", @"🏩", @"💒", @"🏛️", @"⛪️", @"🕌",
            @"🕍", @"🛕", @"🕋", @"⛩️", @"🛤️", @"🛣️", @"🗾", @"🎑", @"🏞️", @"🌅",
            @"🌄", @"🌠", @"🎇", @"🎆", @"🌇", @"🌆", @"🏙️", @"🌃", @"🌌", @"🌉",
            @"🌁"
        ]];
    });
    return data;
}

+ (NSArray <NSString *> *)ObjectsEmoji {
    static dispatch_once_t onceToken;
    static NSArray <NSString *> *data;
    dispatch_once(&onceToken, ^{
        data = [self AsFakeSet:@[
            @"⌚️", @"📱", @"📲", @"💻", @"⌨️", @"🖥️", @"🖨️", @"🖱️", @"🖲️", @"🕹️",
            @"🗜️", @"💽", @"💾", @"💿", @"📀", @"📼", @"📷", @"📸", @"📹", @"🎥",
            @"📽️", @"🎞️", @"📞", @"☎️", @"📟", @"📠", @"📺", @"📻", @"🎙️", @"🎚️",
            @"🎛️", @"🧭", @"⏱️", @"⏲️", @"⏰", @"🕰️", @"⌛️", @"⏳", @"📡", @"🔋",
            @"🪫", @"🔌", @"💡", @"🔦", @"🕯️", @"🪔", @"🧯", @"🛢️", @"💸", @"💵",
            @"💴", @"💶", @"💷", @"🪙", @"💰", @"💳", @"🪪", @"💎", @"⚖️", @"🪜",
            @"🧰", @"🪛", @"🔧", @"🔨", @"⚒️", @"🛠️", @"⛏️", @"🪚", @"🔩", @"⚙️",
            @"🪤", @"🧱", @"⛓️", @"⛓️‍💥", @"🧲", @"🔫", @"💣", @"🧨", @"🪓", @"🔪",
            @"🗡️", @"⚔️", @"🛡️", @"🚬", @"⚰️", @"🪦", @"⚱️", @"🏺", @"🔮", @"📿",
            @"🧿", @"🪬", @"💈", @"⚗️", @"🔭", @"🔬", @"🕳️", @"🩻", @"🩹", @"🩺",
            @"💊", @"💉", @"🩸", @"🧬", @"🦠", @"🧫", @"🧪", @"🌡️", @"🧹", @"🪠",
            @"🧺", @"🧻", @"🚽", @"🚰", @"🚿", @"🛁", @"🛀", @"🧼", @"🪥", @"🪒",
            @"🪮", @"🧽", @"🪣", @"🧴", @"🛎️", @"🔑", @"🗝️", @"🚪", @"🪑", @"🛋️",
            @"🛏️", @"🛌", @"🧸", @"🪆", @"🖼️", @"🪞", @"🪟", @"🛍️", @"🛒", @"🎁",
            @"🎈", @"🎏", @"🎀", @"🪄", @"🪅", @"🎊", @"🎉", @"🎎", @"🪭", @"🏮",
            @"🎐", @"🪩", @"🧧", @"✉️", @"📩", @"📨", @"📧", @"💌", @"📥", @"📤",
            @"📦", @"🏷️", @"🪧", @"📪", @"📫", @"📬", @"📭", @"📮", @"📯", @"📜",
            @"📃", @"📄", @"📑", @"🧾", @"📊", @"📈", @"📉", @"🗒️", @"🗓️", @"📆",
            @"📅", @"🗑️", @"📇", @"🗃️", @"🗳️", @"🗄️", @"📋", @"📁", @"📂", @"🗂️",
            @"🗞️", @"📰", @"📓", @"📔", @"📒", @"📕", @"📗", @"📘", @"📙", @"📚",
            @"📖", @"🔖", @"🧷", @"🔗", @"📎", @"🖇️", @"📐", @"📏", @"🧮", @"📌",
            @"📍", @"✂️", @"🖊️", @"🖋️", @"✒️", @"🖌️", @"🖍️", @"📝", @"✏️", @"🔍",
            @"🔎", @"🔏", @"🔐", @"🔒", @"🔓"
        ]];
    });
    return data;
}

+ (NSArray <NSString *> *)SymbolsEmoji {
    static dispatch_once_t onceToken;
    static NSArray <NSString *> *data;
    dispatch_once(&onceToken, ^{
        data = [self AsFakeSet:@[
            @"🩷", @"❤️", @"🧡", @"💛", @"💚", @"🩵", @"💙", @"💜", @"🖤", @"🩶",
            @"🤍", @"🤎", @"💔", @"❤️‍🔥", @"❤️‍🩹", @"❣️", @"💕", @"💞", @"💓", @"💗",
            @"💖", @"💘", @"💝", @"💟", @"☮️", @"✝️", @"☪️", @"🕉️", @"☸️", @"🪯",
            @"✡️", @"🔯", @"🕎", @"☯️", @"☦️", @"🛐", @"⛎", @"♈️", @"♉️", @"♊️",
            @"♋️", @"♌️", @"♍️", @"♎️", @"♏️", @"♐️", @"♑️", @"♒️", @"♓️", @"🆔",
            @"⚛️", @"🉑", @"☢️", @"☣️", @"📴", @"📳", @"🈶", @"🈚️", @"🈸", @"🈺",
            @"🈷️", @"✴️", @"🆚", @"💮", @"🉐", @"㊙️", @"㊗️", @"🈴", @"🈵", @"🈹",
            @"🈲", @"🅰️", @"🅱️", @"🆎", @"🆑", @"🅾️", @"🆘", @"❌", @"⭕️", @"🛑",
            @"⛔️", @"📛", @"🚫", @"💯", @"💢", @"♨️", @"🚷", @"🚯", @"🚳", @"🚱",
            @"🔞", @"📵", @"🚭", @"❗️", @"❕", @"❓", @"❔", @"‼️", @"⁉️", @"🔅",
            @"🔆", @"〽️", @"⚠️", @"🚸", @"🔱", @"⚜️", @"🔰", @"♻️", @"✅", @"🈯️",
            @"💹", @"❇️", @"✳️", @"❎", @"🌐", @"💠", @"Ⓜ️", @"🌀", @"💤", @"🏧",
            @"🚾", @"♿️", @"🅿️", @"🛗", @"🈳", @"🈂️", @"🛂", @"🛃", @"🛄", @"🛅",
            @"🛜", @"🚹", @"🚺", @"🚼", @"🧑‍🧑‍🧒", @"🧑‍🧑‍🧒‍🧒", @"🧑‍🧒", @"🧑‍🧒‍🧒", @"⚧️", @"🚻",
            @"🚮", @"🎦", @"📶", @"🈁", @"🔣", @"ℹ️", @"🔤", @"🔡", @"🔠", @"🆖",
            @"🆗", @"🆙", @"🆒", @"🆕", @"🆓", @"0️⃣", @"1️⃣", @"2️⃣", @"3️⃣", @"4️⃣",
            @"5️⃣", @"6️⃣", @"7️⃣", @"8️⃣", @"9️⃣", @"🔟", @"🔢", @"#️⃣", @"*️⃣", @"⏏️",
            @"▶️", @"⏸️", @"⏯️", @"⏹️", @"⏺️", @"⏭️", @"⏮️", @"⏩️", @"⏪️", @"⏫️",
            @"⏬️", @"◀️", @"🔼", @"🔽", @"➡️", @"⬅️", @"⬆️", @"⬇️", @"↗️", @"↘️",
            @"↙️", @"↖️", @"↕️", @"↔️", @"↪️", @"↩️", @"⤴️", @"⤵️", @"🔀", @"🔁",
            @"🔂", @"🔄", @"🔃", @"🎵", @"🎶", @"➕", @"➖", @"➗", @"✖️", @"🟰",
            @"♾️", @"💲", @"💱", @"™️", @"©️", @"®️", @"👁️‍🗨️", @"🔚", @"🔙", @"🔛",
            @"🔝", @"🔜", @"〰️", @"➰", @"➿", @"✔️", @"☑️", @"🔘", @"🔴", @"🟠",
            @"🟡", @"🟢", @"🔵", @"🟣", @"⚫️", @"⚪️", @"🟤", @"🔺", @"🔻", @"🔸",
            @"🔹", @"🔶", @"🔷", @"🔳", @"🔲", @"▪️", @"▫️", @"◾️", @"◽️", @"◼️",
            @"◻️", @"🟥", @"🟧", @"🟨", @"🟩", @"🟦", @"🟪", @"⬛️", @"⬜️", @"🟫",
            @"🔈", @"🔇", @"🔉", @"🔊", @"🔔", @"🔕", @"📣", @"📢", @"💬", @"💭",
            @"🗯️", @"♠️", @"♣️", @"♥️", @"♦️", @"🃏", @"🎴", @"🀄️", @"🕐", @"🕑",
            @"🕒", @"🕓", @"🕔", @"🕕", @"🕖", @"🕗", @"🕘", @"🕙", @"🕚", @"🕛",
            @"🕜", @"🕝", @"🕞", @"🕟", @"🕠", @"🕡", @"🕢", @"🕣", @"🕤", @"🕥",
            @"🕦", @"🕧"
        ]];
    });
    return data;
}

+ (NSArray <NSString *> *)FlagsEmoji {
    static dispatch_once_t onceToken;
    static NSArray <NSString *> *data;
    dispatch_once(&onceToken, ^{
        data = [self AsFakeSet:@[
            @"🏳️", @"🏴", @"🏴‍☠️", @"🏁", @"🚩", @"🏳️‍🌈", @"🏳️‍⚧️", @"🇺🇳", @"🇦🇫", @"🇦🇽",
            @"🇦🇱", @"🇩🇿", @"🇦🇸", @"🇦🇩", @"🇦🇴", @"🇦🇮", @"🇦🇶", @"🇦🇬", @"🇦🇷", @"🇦🇲",
            @"🇦🇼", @"🇦🇺", @"🇦🇹", @"🇦🇿", @"🇧🇸", @"🇧🇭", @"🇧🇩", @"🇧🇧", @"🇧🇾", @"🇧🇪",
            @"🇧🇿", @"🇧🇯", @"🇧🇲", @"🇧🇹", @"🇧🇴", @"🇧🇦", @"🇧🇼", @"🇧🇷", @"🇻🇬", @"🇧🇳",
            @"🇧🇬", @"🇧🇫", @"🇧🇮", @"🇰🇭", @"🇨🇲", @"🇨🇦", @"🇮🇨", @"🇨🇻", @"🇧🇶", @"🇰🇾",
            @"🇨🇫", @"🇹🇩", @"🇮🇴", @"🇨🇱", @"🇨🇳", @"🇨🇽", @"🇨🇨", @"🇨🇴", @"🇰🇲", @"🇨🇬",
            @"🇨🇩", @"🇨🇰", @"🇨🇷", @"🇨🇮", @"🇭🇷", @"🇨🇺", @"🇨🇼", @"🇨🇾", @"🇨🇿", @"🇩🇰",
            @"🇩🇯", @"🇩🇲", @"🇩🇴", @"🇪🇨", @"🇪🇬", @"🇸🇻", @"🇬🇶", @"🇪🇷", @"🇪🇪", @"🇸🇿",
            @"🇪🇹", @"🇪🇺", @"🇫🇰", @"🇫🇴", @"🇫🇯", @"🇫🇮", @"🇫🇷", @"🇬🇫", @"🇵🇫", @"🇹🇫",
            @"🇬🇦", @"🇬🇲", @"🇬🇪", @"🇩🇪", @"🇬🇭", @"🇬🇮", @"🇬🇷", @"🇬🇱", @"🇬🇩", @"🇬🇵",
            @"🇬🇺", @"🇬🇹", @"🇬🇬", @"🇬🇳", @"🇬🇼", @"🇬🇾", @"🇭🇹", @"🇭🇳", @"🇭🇰", @"🇭🇺",
            @"🇮🇸", @"🇮🇳", @"🇮🇩", @"🇮🇷", @"🇮🇶", @"🇮🇪", @"🇮🇲", @"🇮🇱", @"🇮🇹", @"🇯🇲",
            @"🇯🇵", @"🎌", @"🇯🇪", @"🇯🇴", @"🇰🇿", @"🇰🇪", @"🇰🇮", @"🇽🇰", @"🇰🇼", @"🇰🇬",
            @"🇱🇦", @"🇱🇻", @"🇱🇧", @"🇱🇸", @"🇱🇷", @"🇱🇾", @"🇱🇮", @"🇱🇹", @"🇱🇺", @"🇲🇴",
            @"🇲🇬", @"🇲🇼", @"🇲🇾", @"🇲🇻", @"🇲🇱", @"🇲🇹", @"🇲🇭", @"🇲🇶", @"🇲🇷", @"🇲🇺",
            @"🇾🇹", @"🇲🇽", @"🇫🇲", @"🇲🇩", @"🇲🇨", @"🇲🇳", @"🇲🇪", @"🇲🇸", @"🇲🇦", @"🇲🇿",
            @"🇲🇲", @"🇳🇦", @"🇳🇷", @"🇳🇵", @"🇳🇱", @"🇳🇨", @"🇳🇿", @"🇳🇮", @"🇳🇪", @"🇳🇬",
            @"🇳🇺", @"🇳🇫", @"🇰🇵", @"🇲🇰", @"🇲🇵", @"🇳🇴", @"🇴🇲", @"🇵🇰", @"🇵🇼", @"🇵🇸",
            @"🇵🇦", @"🇵🇬", @"🇵🇾", @"🇵🇪", @"🇵🇭", @"🇵🇳", @"🇵🇱", @"🇵🇹", @"🇵🇷", @"🇶🇦",
            @"🇷🇪", @"🇷🇴", @"🇷🇺", @"🇷🇼", @"🇼🇸", @"🇸🇲", @"🇸🇹", @"🇸🇦", @"🇸🇳", @"🇷🇸",
            @"🇸🇨", @"🇸🇱", @"🇸🇬", @"🇸🇽", @"🇸🇰", @"🇸🇮", @"🇬🇸", @"🇸🇧", @"🇸🇴", @"🇿🇦",
            @"🇰🇷", @"🇸🇸", @"🇪🇸", @"🇱🇰", @"🇧🇱", @"🇸🇭", @"🇰🇳", @"🇱🇨", @"🇵🇲", @"🇻🇨",
            @"🇸🇩", @"🇸🇷", @"🇸🇪", @"🇨🇭", @"🇸🇾", @"🇹🇼", @"🇹🇯", @"🇹🇿", @"🇹🇭", @"🇹🇱",
            @"🇹🇬", @"🇹🇰", @"🇹🇴", @"🇹🇹", @"🇹🇳", @"🇹🇷", @"🇹🇲", @"🇹🇨", @"🇹🇻", @"🇻🇮",
            @"🇺🇬", @"🇺🇦", @"🇦🇪", @"🇬🇧", @"🏴󠁧󠁢󠁥󠁮󠁧󠁿", @"🏴󠁧󠁢󠁳󠁣󠁴󠁿", @"🏴󠁧󠁢󠁷󠁬󠁳󠁿", @"🇺🇸", @"🇺🇾", @"🇺🇿",
            @"🇻🇺", @"🇻🇦", @"🇻🇪", @"🇻🇳", @"🇼🇫", @"🇪🇭", @"🇾🇪", @"🇿🇲", @"🇿🇼"
        ]];
    });
    return data;
}

+ (NSArray <NSString *> *)OtherFlagsEmoji {
    static dispatch_once_t onceToken;
    static NSArray <NSString *> *data;
    dispatch_once(&onceToken, ^{
        data = [self AsFakeSet:@[
            @"🏳️", @"🏴", @"🏴‍☠️", @"🏁", @"🚩", @"🏳️‍🌈", @"🏳️‍⚧️", @"🇺🇳"
        ]];
    });
    return data;
}

+ (NSArray <NSString *> *)DingbatVariantsEmoji {
    static dispatch_once_t onceToken;
    static NSArray <NSString *> *data;
    dispatch_once(&onceToken, ^{
        data = [self AsFakeSet:@[
            @"❤", @"♥", @"🅰", @"♦", @"🏕", @"🅱", @"🏖", @"♨", @"🗯", @"🏗",
            @"⛪", @"🏘", @"🖥", @"🏙", @"🗳", @"🏚", @"🏛", @"🖨", @"🏜", @"⛲",
            @"⛳", @"🏝", @"🏞", @"⛵", @"🏟", @"🗺", @"🛠", @"⛺", @"◻", @"♻",
            @"◼", @"🛡", @"◽", @"🅾", @"⛽", @"◾", @"🎖", @"🎗", @"🅿", @"♿",
            @"🛢", @"☀", @"🖱", @"🛣", @"☁", @"🛤", @"🖲", @"☂", @"🈚", @"✂",
            @"☃", @"🎙", @"🎚", @"☄", @"🛥", @"🎛", @"🀄", @"⬅", @"✈", @"⬆",
            @"✉", @"🛩", @"⬇", @"🎞", @"🎟", @"✌", @"✍", @"☎", @"✏", @"↔",
            @"☑", @"🕯", @"↕", @"🖼", @"✒", @"↖", @"⚓", @"↗", @"☔", @"⚔",
            @"↘", @"☕", @"✔", @"↙", @"⚖", @"✖", @"🐿", @"⚗", @"🛰", @"⌚",
            @"☘", @"🏳", @"⌛", @"⚙", @"👁", @"🕴", @"🛳", @"⚛", @"🏵", @"🕵",
            @"⚜", @"🗂", @"☝", @"🕶", @"✝", @"🗃", @"⬛", @"🏷", @"⬜", @"㊗",
            @"☠", @"⚠", @"🕷", @"🕸", @"⚡", @"✡", @"☢", @"➡", @"㊙", @"☣",
            @"🕹", @"🗄", @"🈯", @"↩", @"⌨", @"☦", @"↪", @"▪", @"☪", @"⚪",
            @"▫", @"⚫", @"☮", @"☯", @"⚰", @"⚱", @"🈷", @"✳", @"✴", @"🗑",
            @"ℹ", @"▶", @"⤴", @"⤵", @"🗒", @"‼", @"☸", @"🗓", @"☹", @"🌡",
            @"🖇", @"☺", @"⚽", @"⚾", @"🌤", @"🖊", @"◀", @"🌥", @"🖋", @"Ⓜ",
            @"🌦", @"🖌", @"🌧", @"〽", @"🖍", @"⛄", @"❄", @"⁉", @"⛅", @"🌨",
            @"🌩", @"❇", @"♈", @"🌪", @"🖐", @"♉", @"🗜", @"🗝", @"♊", @"🌫",
            @"♋", @"🗞", @"🌬", @"♌", @"♍", @"♎", @"♏", @"♐", @"🗡", @"♑",
            @"♒", @"🕉", @"♓", @"⭐", @"🍽", @"📽", @"⛔", @"🕊", @"🗣", @"🏋",
            @"🏌", @"🛋", @"❗", @"⭕", @"🏍", @"🈂", @"🏎", @"🛍", @"🛎", @"🌶",
            @"🛏", @"♠", @"♣", @"❣", @"🏔"
        ]];
    });
    return data;
}

+ (NSArray <NSString *> *)SkinToneEmoji {
    static dispatch_once_t onceToken;
    static NSArray <NSString *> *data;
    dispatch_once(&onceToken, ^{
        data = [self AsFakeSet:@[
            @"👳", @"🤶", @"🧍", @"👴", @"👂", @"🤷", @"🧎", @"👵", @"👃", @"🤸",
            @"🧏", @"👶", @"🤹", @"👷", @"🧑", @"💪", @"👸", @"👆", @"🧒", @"🕴",
            @"👇", @"🧓", @"🕵", @"👈", @"🤽", @"🧔", @"🚣", @"👉", @"🤌", @"🤾",
            @"🧕", @"👼", @"👊", @"🧖", @"👋", @"🧗", @"👌", @"🤏", @"🧘", @"🕺",
            @"👍", @"🧙", @"👎", @"🧚", @"💁", @"👏", @"🙅", @"🧛", @"💂", @"👐",
            @"⛹", @"🙆", @"🥷", @"💃", @"🙇", @"🧜", @"🧝", @"💅", @"💆", @"💇",
            @"🙋", @"🤘", @"🙌", @"🤙", @"🙍", @"🤚", @"🙎", @"🤛", @"🙏", @"🤜",
            @"🚴", @"✊", @"🚵", @"✋", @"🤞", @"✌", @"🎅", @"🚶", @"✍", @"🤟",
            @"🦵", @"🦶", @"🦸", @"🦹", @"🦻", @"☝", @"🖐", @"🤦", @"🛀", @"👦",
            @"👧", @"🏃", @"🖕", @"👨", @"🏄", @"🖖", @"👩", @"🫰", @"🫱", @"🫲",
            @"🏇", @"🫳", @"🤰", @"🫴", @"👮", @"🤱", @"🫵", @"🏊", @"🫃", @"🤲",
            @"🫶", @"🏋", @"🫄", @"👰", @"🤳", @"🫷", @"🏌", @"🫅", @"👱", @"🤴",
            @"🫸", @"👲", @"🤵"
        ]];
    });
    return data;
}

+ (NSArray <NSString *> *)GenderEmoji {
    static dispatch_once_t onceToken;
    static NSArray <NSString *> *data;
    dispatch_once(&onceToken, ^{
        data = [self AsFakeSet:@[
            @"🧙", @"🤽", @"💆", @"🙍", @"🤾", @"💇", @"🧚", @"🚣", @"🙎", @"🧍",
            @"🧛", @"🧜", @"🧎", @"🧝", @"🧏", @"🏃", @"🚴", @"👮", @"🧞", @"🏄",
            @"🚵", @"⛹", @"👯", @"🤦", @"🤵", @"🚶", @"👰", @"🧟", @"🙅", @"🫃",
            @"👱", @"🫄", @"🙆", @"🤷", @"🫅", @"🙇", @"🤸", @"💁", @"👳", @"🦸",
            @"🤹", @"💂", @"🦹", @"🧖", @"🏊", @"🕵", @"🏋", @"🧗", @"🙋", @"🏌",
            @"🧘", @"👷"
        ]];
    });
    return data;
}

+ (NSArray <NSString *> *)NoneVariantEmoji {
    static dispatch_once_t onceToken;
    static NSArray <NSString *> *data;
    dispatch_once(&onceToken, ^{
        data = [self AsFakeSet:@[
            @"👩‍👩‍👦", @"👨‍👩‍👧‍👧", @"👨‍👩‍👧‍👦", @"👩‍👩‍👧‍👦", @"👩‍👩‍👧‍👧", @"👩‍👧‍👧", @"👨‍👧‍👦", @"👨‍👦‍👦", @"👨‍👨‍👦", @"👩‍👩‍👧",
            @"👨‍👨‍👦‍👦", @"👨‍👧", @"👨‍👧‍👧", @"👨‍👨‍👧", @"👨‍👩‍👦‍👦", @"👩‍👩‍👦‍👦", @"👨‍👩‍👧", @"👨‍👦", @"👩‍👧", @"👩‍👦‍👦",
            @"👁‍🗨", @"👩‍👦", @"👨‍👨‍👧‍👧", @"👨‍👨‍👧‍👦", @"👩‍👧‍👦"
        ]];
    });
    return data;
}

+ (NSArray <NSString *> *)ProfessionEmoji {
    static dispatch_once_t onceToken;
    static NSArray <NSString *> *data;
    dispatch_once(&onceToken, ^{
        data = [self AsFakeSet:@[
            @"👨‍🦲", @"👩‍🦲", @"🧑‍🏫", @"🧑‍💼", @"👨‍💻", @"👩‍💻", @"🧑‍🌾", @"👨‍⚕️", @"👨‍🍳", @"👩‍⚕️",
            @"👩‍🍳", @"👩‍🔧", @"👨‍🔧", @"🧑‍🔬", @"🧑‍🎓", @"🧑‍🚒", @"🧑‍🍼", @"🧔‍♂️", @"🧑‍🦰", @"👨‍🦯",
            @"👩‍🦯", @"👨‍🦳", @"🧑‍🎄", @"👩‍🦳", @"👨‍🏫", @"👨‍💼", @"👩‍🏫", @"👩‍💼", @"🧑‍🦼", @"👨‍🌾",
            @"👩‍🌾", @"👨‍🔬", @"👩‍🔬", @"👨‍🎓", @"👨‍🚒", @"👩‍🎓", @"👨‍🍼", @"👩‍🚒", @"👩‍🍼", @"🧑‍🦱",
            @"👨‍🦰", @"🧑‍✈️", @"👩‍🦰", @"🧑‍🚀", @"🧑‍🏭", @"🧑‍🎤", @"🧑‍🦽", @"👨‍🦼", @"👩‍🦼", @"🧑‍⚖️",
            @"🧑‍🎨", @"🧔‍♀️", @"🧑‍🦲", @"👨‍🦱", @"👨‍✈️", @"👨‍🚀", @"👩‍✈️", @"🐕‍🦺", @"👩‍🚀", @"👩‍🦱",
            @"🧑‍💻", @"👨‍🏭", @"👩‍🏭", @"🧑‍⚕️", @"👨‍🎤", @"🧑‍🍳", @"👩‍🎤", @"👨‍🦽", @"👩‍🦽", @"👨‍⚖️",
            @"👨‍🎨", @"👩‍⚖️", @"👩‍🎨", @"🧑‍🔧", @"🧑‍🦯", @"🧑‍🦳"
        ]];
    });
    return data;
}

+ (NSArray <NSString *> *)PrepopulatedEmoji {
    static dispatch_once_t onceToken;
    static NSArray <NSString *> *data;
    dispatch_once(&onceToken, ^{
        data = [self AsFakeSet:@[
            @"😂", @"❤️", @"😍", @"😒", @"👌", @"☺️", @"😊", @"😘", @"😭", @"😩",
            @"💕", @"😔", @"😏", @"😁", @"😳", @"👍", @"✌️", @"😉", @"😌", @"💁",
            @"🙈", @"😎", @"🎶", @"👀", @"😑", @"😴", @"😄", @"😜", @"😋", @"👏"
        ]];
    });
    return data;
}

+ (NSArray <NSString *> *)ProfessionWithoutSkinToneEmoji {
    static dispatch_once_t onceToken;
    static NSArray <NSString *> *data;
    dispatch_once(&onceToken, ^{
        data = [self AsFakeSet:@[
            @"🐕‍🦺"
        ]];
    });
    return data;
}

+ (NSArray <NSString *> *)CoupleMultiSkinToneEmoji {
    static dispatch_once_t onceToken;
    static NSArray <NSString *> *data;
    dispatch_once(&onceToken, ^{
        data = [self AsFakeSet:@[
            @"👭", @"👬", @"👫", @"🧑‍🤝‍🧑"
        ]];
    });
    return data;
}

+ (NSArray <NSString *> *)ExtendedCoupleMultiSkinToneEmoji {
    static dispatch_once_t onceToken;
    static NSArray <NSString *> *data;
    dispatch_once(&onceToken, ^{
        data = [self AsFakeSet:@[
            @"💏", @"👩‍❤️‍💋‍👩", @"👨‍❤️‍💋‍👨", @"👨‍❤️‍👨", @"👩‍❤️‍💋‍👨", @"👩‍❤️‍👩", @"💑", @"👩‍❤️‍👨"
        ]];
    });
    return data;
}

+ (NSArray <NSString *> *)MultiPersonFamilySkinToneEmoji {
    static dispatch_once_t onceToken;
    static NSArray <NSString *> *data;
    dispatch_once(&onceToken, ^{
        data = [self AsFakeSet:@[
            @"👩‍👩‍👦", @"👨‍👩‍👧‍👧", @"👨‍👩‍👧‍👦", @"👩‍👩‍👧‍👦", @"👩‍👩‍👧‍👧", @"👩‍👧‍👧", @"👨‍👧‍👦", @"👨‍👦‍👦", @"👨‍👨‍👦", @"🧑‍🧒",
            @"👩‍👩‍👧", @"👨‍👩‍👦", @"👨‍👨‍👦‍👦", @"👨‍👧", @"👨‍👧‍👧", @"🧑‍🧑‍🧒", @"🧑‍🧑‍🧒‍🧒", @"👨‍👨‍👧", @"🧑‍🤝‍🧑", @"👨‍👩‍👦‍👦",
            @"👩‍👩‍👦‍👦", @"👨‍👩‍👧", @"👨‍👦", @"👩‍👧", @"🧑‍🧒‍🧒", @"👩‍👦‍👦", @"👩‍👦", @"👨‍👨‍👧‍👧", @"👨‍👨‍👧‍👦", @"👩‍👧‍👦"
        ]];
    });
    return data;
}

@end
